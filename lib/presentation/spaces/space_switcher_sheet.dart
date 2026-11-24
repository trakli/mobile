import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/spaces/space_format.dart';
import 'package:trakli/presentation/spaces/space_invitation_screen.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

Future<void> showSpaceSwitcherSheet(BuildContext context) {
  final cubit = context.read<SpaceCubit>();
  cubit.loadSpaces();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: const SpaceSwitcherSheet(),
    ),
  );
}

class SpaceSwitcherSheet extends StatelessWidget {
  const SpaceSwitcherSheet({super.key});

  Future<void> _create(BuildContext context) async {
    final cubit = context.read<SpaceCubit>();
    final navigator = Navigator.of(context);
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _CreateSpaceSheet(),
      ),
    );
    if (created == true && navigator.mounted) navigator.pop();
  }

  Future<void> _openInvitation(BuildContext context) async {
    final cubit = context.read<SpaceCubit>();
    final navigator = Navigator.of(context);
    final token = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _InvitationLinkSheet(),
    );
    if (token == null || !navigator.mounted) return;
    navigator.pop();
    await navigator.push(MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: SpaceInvitationScreen(token: token),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return BlocBuilder<SpaceCubit, SpaceState>(
      builder: (context, state) {
        final cubit = context.read<SpaceCubit>();
        void pick(String? slug) {
          Navigator.of(context).pop();
          if (slug != state.activeSlug) cubit.switchTo(slug);
        }

        final loadFailed = !state.hasLoadedSpaces &&
            !state.isLoadingSpaces &&
            state.failure != const Failure.none();

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 14.lx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const LedgerSheetHandle(),
                SizedBox(height: 12.lx),
                LedgerH6(LocaleKeys.homeSwitchSpace.tr()),
                SizedBox(height: 4.lx),
                _SpaceOption(
                  icon: LucideIcons.user,
                  title: LocaleKeys.spacePersonal.tr(),
                  subtitle: LocaleKeys.spaceOnlyYou.tr(),
                  active: state.isPersonal,
                  onTap: () => pick(null),
                ),
                for (final space in state.spaces)
                  _SpaceOption(
                    icon: LucideIcons.users,
                    title: space.name,
                    subtitle: [
                      LocaleKeys.spaceSharedSpace.tr(),
                      spacePeopleLabel(space.memberCount),
                    ].join(' · '),
                    badge: space.readOnly
                        ? LedgerChip(
                            LocaleKeys.spaceNotActive.tr(),
                            tone: LedgerChipTone.warm,
                          )
                        : null,
                    active: state.activeSlug == space.slug,
                    onTap: () => pick(space.slug),
                  ),
                if (state.isLoadingSpaces && !state.hasLoadedSpaces)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.lx),
                    child: Center(
                      child: SizedBox(
                        width: 18.lx,
                        height: 18.lx,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: t.brandText,
                        ),
                      ),
                    ),
                  ),
                if (loadFailed)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.lx),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            LocaleKeys.spaceLoadError.tr(),
                            style: TextStyle(
                              fontSize: 12.5.lx,
                              color: t.textSecondary,
                            ),
                          ),
                        ),
                        LedgerButton(
                          label: LocaleKeys.retry.tr(),
                          icon: LucideIcons.refreshCw,
                          style: LedgerButtonStyle.outline,
                          onPressed: cubit.loadSpaces,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 12.lx),
                Row(
                  children: [
                    if (state.canCreate) ...[
                      Expanded(
                        child: LedgerButton(
                          label: LocaleKeys.spaceCreate.tr(),
                          icon: LucideIcons.plus,
                          style: LedgerButtonStyle.outline,
                          large: true,
                          onPressed: () => _create(context),
                        ),
                      ),
                      SizedBox(width: 8.lx),
                    ],
                    Expanded(
                      child: LedgerButton(
                        label: LocaleKeys.spaceOpenInvitation.tr(),
                        icon: LucideIcons.mailOpen,
                        style: LedgerButtonStyle.outline,
                        large: true,
                        onPressed: () => _openInvitation(context),
                      ),
                    ),
                  ],
                ),
                if (state.hasLoadedSpaces && !state.canCreate) ...[
                  SizedBox(height: 10.lx),
                  Text(
                    LocaleKeys.spaceCannotCreate.tr(),
                    style: TextStyle(
                      fontSize: 12.lx,
                      height: 1.4,
                      color: t.textMuted,
                    ),
                  ),
                ],
                SizedBox(height: 12.lx),
                LedgerNote(
                  icon: LucideIcons.lock,
                  text: LocaleKeys.spacePrivacyNote.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SpaceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool active;
  final Widget? badge;
  final VoidCallback onTap;

  const _SpaceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.active,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return LedgerRow(
      leading: LedgerCoin(icon: icon, size: 32),
      title: title,
      titleStyle: TextStyle(
        fontSize: 13.5.lx,
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        color: t.textPrimary,
      ),
      subtitle: subtitle,
      verticalPadding: 10,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null) ...[badge!, SizedBox(width: 8.lx)],
          Icon(
            active ? LucideIcons.check : LucideIcons.chevronRight,
            size: 17.lx,
            color: active ? t.brandText : t.textPrimary,
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool autofocus;

  const _SheetField({
    required this.label,
    required this.controller,
    this.hint,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.lx, color: t.textMuted)),
        SizedBox(height: 6.lx),
        TextField(
          controller: controller,
          autofocus: autofocus,
          style: TextStyle(fontSize: 14.lx, color: t.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: t.bgSurface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.lx,
              vertical: 11.lx,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              borderSide: BorderSide(color: t.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              borderSide: BorderSide(color: t.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              borderSide: BorderSide(color: t.brandText),
            ),
          ),
        ),
      ],
    );
  }
}

class _CreateSpaceSheet extends StatefulWidget {
  const _CreateSpaceSheet();

  @override
  State<_CreateSpaceSheet> createState() => _CreateSpaceSheetState();
}

class _CreateSpaceSheetState extends State<_CreateSpaceSheet> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    final navigator = Navigator.of(context);
    final space = await context.read<SpaceCubit>().createSpace(
          _name.text.trim(),
          description: _description.text.trim(),
        );
    if (space != null && navigator.mounted) navigator.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return BlocBuilder<SpaceCubit, SpaceState>(
      builder: (context, state) {
        final error = _submitted && state.failure != const Failure.none()
            ? state.failure.customMessage
            : null;
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 14.lx),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LedgerSheetHandle(),
                SizedBox(height: 12.lx),
                LedgerH6(LocaleKeys.spaceCreateTitle.tr()),
                SizedBox(height: 6.lx),
                Text(
                  LocaleKeys.spaceCreateHint.tr(),
                  style: TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
                ),
                SizedBox(height: 14.lx),
                _SheetField(
                  label: LocaleKeys.spaceNameLabel.tr(),
                  hint: LocaleKeys.spaceNamePlaceholder.tr(),
                  controller: _name,
                  autofocus: true,
                ),
                SizedBox(height: 12.lx),
                _SheetField(
                  label: LocaleKeys.spaceDescriptionLabel.tr(),
                  controller: _description,
                ),
                if (error != null) ...[
                  SizedBox(height: 10.lx),
                  Text(
                    error,
                    style: TextStyle(fontSize: 12.lx, color: t.expenseColor),
                  ),
                ],
                SizedBox(height: 14.lx),
                LedgerButton(
                  label: LocaleKeys.spaceCreateAction.tr(),
                  icon: LucideIcons.plus,
                  large: true,
                  busy: state.isCreating,
                  onPressed: _name.text.trim().isEmpty ? null : _submit,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pulls the token out of an invitation link (`.../invitations/<token>`),
/// or returns the input when it is already a bare token.
String? spaceInvitationToken(String input) {
  final text = input.trim();
  if (text.isEmpty) return null;
  final match = RegExp(r'invitations/([^/?#\s]+)').firstMatch(text);
  if (match != null) return Uri.decodeComponent(match.group(1)!);
  if (text.contains('/') || text.contains(' ')) return null;
  return text;
}

class _InvitationLinkSheet extends StatefulWidget {
  const _InvitationLinkSheet();

  @override
  State<_InvitationLinkSheet> createState() => _InvitationLinkSheetState();
}

class _InvitationLinkSheetState extends State<_InvitationLinkSheet> {
  final _link = TextEditingController();

  @override
  void initState() {
    super.initState();
    _link.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _link.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final token = spaceInvitationToken(_link.text);
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 14.lx),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const LedgerSheetHandle(),
            SizedBox(height: 12.lx),
            LedgerH6(LocaleKeys.spaceInvitationLinkTitle.tr()),
            SizedBox(height: 12.lx),
            _SheetField(
              label: LocaleKeys.spaceInvitationLinkHint.tr(),
              controller: _link,
              autofocus: true,
            ),
            SizedBox(height: 14.lx),
            LedgerButton(
              label: LocaleKeys.spaceContinue.tr(),
              icon: LucideIcons.arrowRight,
              large: true,
              onPressed:
                  token == null ? null : () => Navigator.of(context).pop(token),
            ),
          ],
        ),
      ),
    );
  }
}

