import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

Future<void> showShareToSpaceSheet(
  BuildContext context,
  TransactionCompleteEntity transaction,
) {
  final cubit = context.read<SpaceCubit>();
  if (!cubit.state.hasLoadedSpaces) cubit.loadSpaces();
  final messenger = ScaffoldMessenger.maybeOf(context);
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: ShareToSpaceSheet(
        transaction: transaction,
        initialSlugs: [
          if (cubit.state.activeSpace?.canWrite ?? false)
            cubit.state.activeSlug!,
        ],
      ),
    ),
  ).then((message) {
    if (message != null) {
      messenger?.showSnackBar(SnackBar(content: Text(message)));
    }
  });
}

class ShareToSpaceSheet extends StatefulWidget {
  final TransactionCompleteEntity transaction;
  final List<String> initialSlugs;

  const ShareToSpaceSheet({
    super.key,
    required this.transaction,
    this.initialSlugs = const [],
  });

  @override
  State<ShareToSpaceSheet> createState() => _ShareToSpaceSheetState();
}

class _ShareToSpaceSheetState extends State<ShareToSpaceSheet> {
  final List<String> _selected = [];
  final Map<String, int?> _labels = {};
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    for (final slug in widget.initialSlugs) {
      _toggle(slug, true);
    }
  }

  void _toggle(String slug, bool on) {
    setState(() {
      _selected.remove(slug);
      if (on) _selected.add(slug);
    });
    if (on) context.read<SpaceCubit>().loadLabels(slug);
  }

  SpaceOverviewEntity? _overview(SpaceState state, String slug) =>
      state.overviewsBySlug[slug] ??
      (state.activeSlug == slug ? state.overview : null);

  /// The chosen label, or the space category whose name matches the
  /// transaction's own category.
  int? _labelFor(SpaceState state, String slug) {
    if (_labels.containsKey(slug)) return _labels[slug];
    final overview = _overview(state, slug);
    if (overview == null) return null;
    final names = widget.transaction.categories
        .map((c) => c.name.trim().toLowerCase())
        .toSet();
    for (final c in overview.categories) {
      if (names.contains(c.name.trim().toLowerCase())) return c.id;
    }
    return null;
  }

  String _subtitle(SpaceState state, SpaceEntity space) {
    if (space.readOnly) return LocaleKeys.spaceNotActive.tr();
    if (_selected.contains(space.slug)) {
      final label = _labelFor(state, space.slug);
      final overview = _overview(state, space.slug);
      if (label != null && overview != null) {
        for (final b in overview.budgets) {
          if (b.isActive && b.categoryIds.contains(label)) {
            return LocaleKeys.spaceCountsToward
                .tr(namedArgs: {'budget': b.name});
          }
        }
      }
    }
    return LocaleKeys.spaceSharedSpace.tr();
  }

  Future<void> _share(SpaceState state) async {
    final id = widget.transaction.transaction.id;
    if (id == null) return;
    setState(() => _submitted = true);
    final navigator = Navigator.of(context);
    final labels = {
      for (final slug in _selected)
        slug: [if (_labelFor(state, slug) != null) _labelFor(state, slug)!],
    };
    final ok = await context.read<SpaceCubit>().share(id, labels);
    if (!ok || !navigator.mounted) return;
    final names = _selected
        .map((s) => state.spaceBySlug(s)?.name ?? s)
        .toList(growable: false);
    navigator.pop(names.length == 1
        ? LocaleKeys.spaceSharedWith.tr(namedArgs: {'name': names.first})
        : LocaleKeys.spaceSharedWithCount
            .tr(namedArgs: {'count': '${names.length}'}));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final synced = widget.transaction.transaction.id != null;
    return BlocBuilder<SpaceCubit, SpaceState>(
      builder: (context, state) {
        final error = _submitted && state.failure != const Failure.none()
            ? state.failure.customMessage
            : null;
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 14.lx),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const LedgerSheetHandle(),
                SizedBox(height: 12.lx),
                LedgerH6(LocaleKeys.spaceShareTitle.tr()),
                SizedBox(height: 10.lx),
                if (state.hasLoadedSpaces && state.spaces.isEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.lx),
                    child: Text(
                      LocaleKeys.spaceShareNoSpaces.tr(),
                      style:
                          TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
                    ),
                  ),
                if (!state.hasLoadedSpaces && state.isLoadingSpaces)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.lx),
                    child: Center(
                      child: CircularProgressIndicator(color: t.brandText),
                    ),
                  ),
                for (final space in state.spaces) ...[
                  _SpaceToggle(
                    space: space,
                    subtitle: _subtitle(state, space),
                    on: _selected.contains(space.slug),
                    onChanged: space.canWrite && synced
                        ? (v) => _toggle(space.slug, v)
                        : null,
                  ),
                  SizedBox(height: 8.lx),
                ],
                for (final slug in _selected)
                  if (_overview(state, slug) != null) ...[
                    SizedBox(height: 4.lx),
                    Text(
                      LocaleKeys.spaceLabelIn.tr(namedArgs: {
                        'name': state.spaceBySlug(slug)?.name ?? '',
                      }),
                      style: TextStyle(fontSize: 12.lx, color: t.textMuted),
                    ),
                    SizedBox(height: 6.lx),
                    _LabelSelect(
                      labels: _overview(state, slug)!
                          .categories
                          .where((c) =>
                              c.type == null ||
                              c.type ==
                                  (widget.transaction.transaction.type.name))
                          .toList(),
                      value: _labelFor(state, slug),
                      onChanged: (v) => setState(() => _labels[slug] = v),
                    ),
                    SizedBox(height: 10.lx),
                  ],
                SizedBox(height: 2.lx),
                LedgerNote(
                  icon: LucideIcons.lock,
                  text: synced
                      ? LocaleKeys.spaceSharePrivacy.tr()
                      : LocaleKeys.spaceShareNeedsSync.tr(),
                ),
                if (error != null) ...[
                  SizedBox(height: 10.lx),
                  Text(
                    error,
                    style: TextStyle(fontSize: 12.lx, color: t.expenseColor),
                  ),
                ],
                SizedBox(height: 12.lx),
                LedgerButton(
                  label: LocaleKeys.spaceShareAction.tr(),
                  icon: LucideIcons.share2,
                  large: true,
                  busy: state.isSharing,
                  onPressed: synced && _selected.isNotEmpty
                      ? () => _share(state)
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SpaceToggle extends StatelessWidget {
  final SpaceEntity space;
  final String subtitle;
  final bool on;
  final ValueChanged<bool>? onChanged;

  const _SpaceToggle({
    required this.space,
    required this.subtitle,
    required this.on,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Opacity(
      opacity: onChanged == null && !on ? 0.6 : 1,
      child: LedgerCard(
        borderColor: on ? t.brandText : null,
        padding: EdgeInsets.symmetric(horizontal: 10.lx, vertical: 9.lx),
        onTap: onChanged == null ? null : () => onChanged!(!on),
        child: Row(
          children: [
            const LedgerCoin(icon: LucideIcons.users, size: 32),
            SizedBox(width: 11.lx),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    space.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5.lx,
                      fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                      color: t.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.lx, color: t.textMuted),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.lx),
            LedgerToggle(value: on, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _LabelSelect extends StatelessWidget {
  final List<SpaceLabelEntity> labels;
  final int? value;
  final ValueChanged<int?> onChanged;

  const _LabelSelect({
    required this.labels,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final style = Theme.of(context)
        .textTheme
        .bodyMedium!
        .copyWith(fontSize: 13.5.lx, color: t.textPrimary);
    final current = labels.any((l) => l.id == value) ? value : null;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.lx),
      decoration: BoxDecoration(
        color: t.bgSurface,
        border: Border.all(color: t.borderLight),
        borderRadius: BorderRadius.circular(AppRadii.sm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          isExpanded: true,
          value: current,
          dropdownColor: t.bgSurface,
          icon: Icon(LucideIcons.chevronDown, size: 16.lx, color: t.textPrimary),
          style: style,
          items: [
            DropdownMenuItem<int?>(
              value: null,
              child: Text(LocaleKeys.spaceNoLabel.tr(), style: style),
            ),
            for (final l in labels)
              DropdownMenuItem<int?>(
                value: l.id,
                child: Text(l.name, style: style),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
