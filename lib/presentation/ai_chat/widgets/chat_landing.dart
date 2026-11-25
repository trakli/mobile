import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/data/datasources/ai/dto/chat_session_dto.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/ai_chat/widgets/trakli_mark.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class ChatLanding extends StatefulWidget {
  final void Function(String) onPick;
  final ChatSessionDto? recentSession;
  final VoidCallback onContinue;
  const ChatLanding({
    super.key,
    required this.onPick,
    required this.onContinue,
    this.recentSession,
  });

  @override
  State<ChatLanding> createState() => ChatLandingState();
}

class ChatLandingState extends State<ChatLanding>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _resumeDismissed = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return LocaleKeys.aiGreetingMorning.tr();
    if (hour < 17) return LocaleKeys.aiGreetingAfternoon.tr();
    return LocaleKeys.aiGreetingEvening.tr();
  }

  /// Staggered fade + rise entrance animation for landing sections.
  Widget _stagger(int index, Widget child) {
    final start = (index * 0.07).clamp(0.0, 0.5);
    final anim = CurvedAnimation(
      parent: _anim,
      curve: Interval(start, (start + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    );
    return AnimatedBuilder(
      animation: anim,
      builder: (context, _) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 14.h * (1 - anim.value)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final firstName =
        context.watch<AuthCubit>().state.user?.firstName.trim() ?? '';
    final greeting =
        firstName.isEmpty ? _greeting() : '${_greeting()}, $firstName';

    final suggestions = <(String, IconData)>[
      (LocaleKeys.aiSuggestSpendMonth.tr(), LucideIcons.wallet),
      (LocaleKeys.aiSuggestTopCategory.tr(), LucideIcons.chartPie),
      (LocaleKeys.aiSuggestIncomeVsExpense.tr(), LucideIcons.chartLine),
      (LocaleKeys.aiSuggestBalance.tr(), LucideIcons.landmark),
    ];

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 14.lx, vertical: 24.lx),
      children: [
        SizedBox(height: 8.h),
        _stagger(0, _hero(tones)),
        SizedBox(height: 20.h),
        _stagger(
          1,
          Text(
            greeting,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textPrimary,
              fontSize: 20.lx,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _stagger(
          2,
          Text(
            LocaleKeys.aiChatEmptyHint.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tones.textSecondary,
              fontSize: 13.lx,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        if (widget.recentSession != null && !_resumeDismissed) ...[
          SizedBox(height: 20.h),
          _stagger(4, _resumeOptions(tones)),
        ],
        SizedBox(height: 24.h),
        ...suggestions.asMap().entries.map(
              (e) => _stagger(
                5 + e.key,
                Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: _suggestionChip(tones, e.value.$1, e.value.$2),
                ),
              ),
            ),
      ],
    );
  }

  Widget _hero(AppTones tones) {
    return const Center(child: TrakliMark(height: 44));
  }

  /// Compact, vertically-stacked resume options shown under the stats slider.
  Widget _resumeOptions(AppTones tones) {
    final rawTitle = widget.recentSession?.title?.trim() ?? '';
    final title = rawTitle.isEmpty ? LocaleKeys.aiChatUntitled.tr() : rawTitle;
    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(color: tones.textMuted, fontSize: 11.5.lx),
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiContinueSession.tr(),
          icon: LucideIcons.history,
          filled: true,
          onTap: widget.onContinue,
        ),
        SizedBox(height: 8.h),
        _pillButton(
          tones,
          label: LocaleKeys.aiStartNewSession.tr(),
          icon: LucideIcons.plus,
          filled: false,
          onTap: () => setState(() => _resumeDismissed = true),
        ),
      ],
    );
  }

  Widget _pillButton(
    AppTones tones, {
    required String label,
    required IconData icon,
    required bool filled,
    required VoidCallback onTap,
  }) {
    return Center(
      child: LedgerButton(
        label: label,
        icon: icon,
        style: filled ? LedgerButtonStyle.filled : LedgerButtonStyle.outline,
        onPressed: onTap,
      ),
    );
  }

  Widget _suggestionChip(AppTones tones, String q, IconData icon) {
    return LedgerCard(
      onTap: () => widget.onPick(q),
      padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 11.lx),
      child: Row(
        children: [
          LedgerCoin(icon: icon, size: 28),
          SizedBox(width: 10.lx),
          Expanded(
            child: Text(
              q,
              style: TextStyle(
                color: tones.textPrimary,
                fontSize: 13.lx,
                height: 1.4,
              ),
            ),
          ),
          Icon(LucideIcons.arrowUpRight, size: 15.lx, color: tones.textMuted),
        ],
      ),
    );
  }
}
