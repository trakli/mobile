import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:trakli/data/datasources/ai/dto/chat_blocks_dto.dart';
import 'package:trakli/data/datasources/ai/dto/chat_message_dto.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/cubit/ai_chat_cubit.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_block_widget.dart';
import 'package:trakli/presentation/ai_chat/widgets/blocks/chat_legacy_result.dart';
import 'package:trakli/presentation/ai_chat/widgets/proposed_action_card.dart';
import 'package:trakli/presentation/ai_chat/widgets/trakli_mark.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

class MessageRow extends StatelessWidget {
  final ChatMessageDto message;
  const MessageRow({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isUser) {
      return Padding(
        padding: EdgeInsets.only(bottom: 12.lx),
        child: Align(
          alignment: Alignment.centerRight,
          child: FractionallySizedBox(
            widthFactor: 0.88,
            alignment: Alignment.centerRight,
            child: Align(
              alignment: Alignment.centerRight,
              child: _Bubble(message: message),
            ),
          ),
        ),
      );
    }

    final blocks = message.blocks;
    final legacy = message.legacyResult;
    final hasContent = message.displayText.trim().isNotEmpty;

    final showContentBubble = message.isInFlight ||
        message.isFailed ||
        message.isServiceUnavailable ||
        (hasContent && blocks.isEmpty);

    const structured = ['table', 'list', 'pair_list', 'record'];
    final legacyToShow = (blocks.isEmpty &&
            legacy != null &&
            (!hasContent || structured.contains(legacy.formatType)))
        ? legacy
        : null;

    final showBubble =
        showContentBubble || (blocks.isEmpty && legacyToShow == null);

    return Padding(
      padding: EdgeInsets.only(bottom: 14.lx),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TrakliMark(),
          SizedBox(width: 8.lx),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showBubble) _Bubble(message: message),
                for (final block in blocks)
                  if (block is ProposedActionBlock)
                    Padding(
                      padding: EdgeInsets.only(top: 8.lx),
                      child: ProposedActionCard(
                        key: ValueKey(block.id),
                        block: block,
                      ),
                    )
                  else
                    ChatBlockWidget(block: block),
                if (legacyToShow != null)
                  ChatLegacyResult(result: legacyToShow),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessageDto message;
  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final isUser = message.isUser;
    final inFlight = message.isInFlight;
    final failed = message.isFailed;

    if (isUser) {
      return GestureDetector(
        onLongPress: () => _copy(context, message.displayText),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.lx, vertical: 10.lx),
          decoration: BoxDecoration(
            color: tones.surface3,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadii.xl),
              topRight: Radius.circular(AppRadii.xl),
              bottomLeft: Radius.circular(AppRadii.xl),
              bottomRight: Radius.circular(AppRadii.xs),
            ),
          ),
          child: Text(
            message.displayText,
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 13.lx,
              height: 1.45,
            ),
          ),
        ),
      );
    }

    final fg = failed ? tones.expenseColor : tones.textPrimary;
    final isError = failed || message.isServiceUnavailable;

    final String errorText = failed
        ? (message.error ?? LocaleKeys.aiChatError.tr())
        : LocaleKeys.aiServiceUnavailable.tr();
    final copyText = inFlight
        ? ''
        : isError
            ? errorText
            : message.displayText;

    final textStyle = TextStyle(color: fg, fontSize: 13.lx, height: 1.5);
    final Widget body;
    if (inFlight) {
      body = Padding(
        padding: EdgeInsets.symmetric(vertical: 6.lx),
        child: _ThinkingDots(color: tones.brandText),
      );
    } else if (isError) {
      body = Text(errorText, style: textStyle);
    } else {
      body = GptMarkdown(message.displayText, style: textStyle);
    }

    return GestureDetector(
      onLongPress: () => _copy(context, copyText),
      child: Container(
        width: double.infinity,
        padding: isError ? EdgeInsets.all(10.lx) : EdgeInsets.zero,
        decoration: isError
            ? BoxDecoration(
                color: tones.expenseSoft,
                borderRadius: BorderRadius.circular(AppRadii.md),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            body,
            if (isError) ...[
              SizedBox(height: 6.lx),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => context.read<AiChatCubit>().retry(message.id),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.lx, vertical: 2.lx),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.refreshCw,
                            size: 13.lx, color: tones.brandText),
                        SizedBox(width: 4.lx),
                        Text(
                          LocaleKeys.retry.tr(),
                          style: TextStyle(
                            fontSize: 12.lx,
                            fontWeight: FontWeight.w600,
                            color: tones.brandText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copy(BuildContext context, String text) {
    if (text.trim().isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.copiedToClipboard.tr()),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _ThinkingDots extends StatefulWidget {
  final Color color;
  const _ThinkingDots({required this.color});

  @override
  State<_ThinkingDots> createState() => _ThinkingDotsState();
}

class _ThinkingDotsState extends State<_ThinkingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctl;

  @override
  void initState() {
    super.initState();
    _ctl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctl,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_ctl.value + i * 0.2) % 1.0;
            final scale = 0.6 + 0.4 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 7.r,
                  height: 7.r,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
