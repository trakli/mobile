import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/ai_chat/dictation/dictation_cubit.dart';
import 'package:trakli/presentation/ai_chat/widgets/chat_composer.dart';
import 'package:trakli/presentation/ai_chat/widgets/chat_history_sheet.dart';
import 'package:trakli/presentation/ai_chat/widgets/chat_landing.dart';
import 'package:trakli/presentation/ai_chat/widgets/message_bubble.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final AiChatCubit _cubit = getIt<AiChatCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.openInitial();
  }

  @override
  void dispose() {
    _cubit.pausePolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider(create: (_) => getIt<DictationCubit>()),
      ],
      child: const _AiChatView(),
    );
  }
}

class _AiChatView extends StatefulWidget {
  const _AiChatView();

  @override
  State<_AiChatView> createState() => _AiChatViewState();
}

class _AiChatViewState extends State<_AiChatView> {
  final _composer = TextEditingController();
  final _scroll = ScrollController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _composer.dispose();
    _scroll.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _openHistorySheet(BuildContext context) {
    final cubit = context.read<AiChatCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HistorySheet(cubit: cubit),
    );
  }

  void _send([String? overrideText]) {
    final text = (overrideText ?? _composer.text).trim();
    if (text.isEmpty) return;
    context.read<DictationCubit>().cancel();
    context.read<AiChatCubit>().sendMessage(text);
    _composer.clear();
    _focus.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _sendMessage(String text, List<File> files, String? documentType) {
    final trimmed = text.trim();
    if (trimmed.isEmpty && files.isEmpty) return;
    context.read<AiChatCubit>().sendMessage(
          trimmed,
          files: files.isEmpty ? null : files,
          documentType: documentType,
        );
    _composer.clear();
    _focus.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      _scroll.position.maxScrollExtent,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Scaffold(
      backgroundColor: tones.bgPage,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<AiChatCubit, AiChatState>(
          listenWhen: (a, b) =>
              a.messages.length != b.messages.length ||
              (a.isPolling && !b.isPolling),
          listener: (context, state) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => _scrollToBottom());
          },
          builder: (context, state) {
            final hasContent =
                state.messages.isNotEmpty || state.recentSession != null;
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 6.lx),
                  child: LedgerScreenBar(
                    title: LocaleKeys.aiChatTitle.tr(),
                    leadingIcon: LucideIcons.chevronLeft,
                    actions: [
                      if (state.hasSession)
                        LedgerIconButton(
                          icon: LucideIcons.messageSquarePlus,
                          tooltip: LocaleKeys.aiChatNewChat.tr(),
                          onTap: () =>
                              context.read<AiChatCubit>().startNewChat(),
                        ),
                      LedgerIconButton(
                        icon: LucideIcons.history,
                        tooltip: LocaleKeys.aiChatHistory.tr(),
                        onTap: () => _openHistorySheet(context),
                      ),
                    ],
                  ),
                ),
                if (state.isInitializing && hasContent)
                  LinearProgressIndicator(
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                    color: tones.brandFill,
                  ),
                if (state.failure != null) _ErrorBanner(state: state),
                Expanded(
                  child: state.isInitializing && !hasContent
                      ? Center(
                          child: CircularProgressIndicator(
                            color: tones.brandFill,
                          ),
                        )
                      : state.isEmpty
                          ? ChatLanding(
                              onPick: _send,
                              recentSession: state.recentSession,
                              onContinue: () {
                                final id = state.recentSession?.id;
                                if (id != null) {
                                  context.read<AiChatCubit>().openSession(id);
                                }
                              },
                            )
                          : ListView.builder(
                              controller: _scroll,
                              padding: EdgeInsets.fromLTRB(
                                  14.lx, 6.lx, 14.lx, 12.lx),
                              itemCount: state.messages.length,
                              itemBuilder: (context, i) {
                                return MessageRow(message: state.messages[i]);
                              },
                            ),
                ),
                Composer(
                  controller: _composer,
                  focus: _focus,
                  isSending: state.isBusy,
                  onSend: _sendMessage,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final AiChatState state;
  const _ErrorBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    return Container(
      margin: EdgeInsets.fromLTRB(14.lx, 4.lx, 14.lx, 4.lx),
      padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 9.lx),
      decoration: BoxDecoration(
        color: tones.expenseSoft,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.circleAlert, color: tones.expenseColor, size: 16.lx),
          SizedBox(width: 10.lx),
          Expanded(
            child: Text(
              state.failure?.maybeMap(
                    networkError: (f) => f.customMessage,
                    orElse: () => LocaleKeys.aiChatError.tr(),
                  ) ??
                  LocaleKeys.aiChatError.tr(),
              style: TextStyle(
                color: tones.expenseColor,
                fontSize: 12.5.lx,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
