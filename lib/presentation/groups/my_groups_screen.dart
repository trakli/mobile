import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/ui_constants.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/add_group_screen.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/groups/widgets/group_list_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/education_banner.dart';
import 'package:trakli/presentation/utils/ledger/ledger_empty.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({super.key});

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  bool _bannerDismissed = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<GroupCubit>()..getGroups(),
      child: Builder(builder: (context) {
        final t = context.tones;
        void add() => AppNavigator.push(context, const AddGroupScreen());
        return Scaffold(
          backgroundColor: t.bgPage,
          appBar: PageAppBar(
            title: LocaleKeys.groupsMyGroups.tr(),
            onSearchChanged: (v) => setState(() => _query = v),
            searchHint: LocaleKeys.groupsSearchHint.tr(),
            actions: [
              PageAppBarAction(
                icon: LucideIcons.plus,
                onTap: add,
                primary: true,
              ),
            ],
          ),
          body: BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              if (state.groups.isEmpty) {
                return LedgerEmptyState(
                  loading: state.isLoading,
                  icon: LucideIcons.folder,
                  title: state.failure.hasError
                      ? state.failure.customMessage
                      : LocaleKeys.noGroupsFound.tr(),
                  body: state.failure.hasError
                      ? null
                      : LocaleKeys.groupsEmptyBody.tr(),
                  actionLabel: LocaleKeys.addGroup.tr(),
                  onAction: add,
                );
              }
              final q = _query.trim().toLowerCase();
              final filtered = q.isEmpty
                  ? state.groups
                  : state.groups
                      .where((g) => '${g.name} ${g.description ?? ''}'
                          .toLowerCase()
                          .contains(q))
                      .toList();
              return ListView(
                padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
                children: [
                  if (state.groups.length <
                          UiConstants.educationBannerThreshold &&
                      !_bannerDismissed)
                    EducationBanner(
                      message: LocaleKeys.groupEducationBanner.tr(),
                      icon: LucideIcons.folder,
                      onDismiss: () => setState(() => _bannerDismissed = true),
                    ),
                  if (filtered.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.lx),
                      child: Text(
                        LocaleKeys.walletsNoMatchQuery
                            .tr(args: [_query.trim()]),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13.lx, color: t.textMuted),
                      ),
                    )
                  else
                    LedgerCard(
                      padding: EdgeInsets.symmetric(horizontal: 12.lx),
                      child: Column(
                        children: [
                          for (final g in filtered)
                            GroupListTile(
                              group: g,
                              divider: g != filtered.last,
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
