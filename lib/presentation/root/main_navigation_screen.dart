import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/sync/sync_database.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/transactions/quick_add/quick_add_sheet.dart';
import 'package:trakli/presentation/utils/bottom_nav.dart';
import 'package:trakli/presentation/utils/custom_drawer.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final List<Widget> screens =
      NavigationScreen.values.map((e) => e.screen).toList();

  @override
  void initState() {
    super.initState();
    // Reset the scaffold key to avoid duplicate key errors
    resetScaffoldKey();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainNavigationCubit(),
      child: BlocBuilder<MainNavigationCubit, MainNavigationPageState>(
        builder: (context, state) {
          final cubit = context.read<MainNavigationCubit>();
          return Scaffold(
            key: scaffoldKey,
            resizeToAvoidBottomInset: false,
            drawer: Drawer(
              shape: const RoundedRectangleBorder(),
              width: 0.8.sw,
              child: const CustomDrawer(),
            ),
            body: RefreshIndicator(
              displacement: 20.0,
              onRefresh: () async {
                final isAuthenticated =
                    context.read<AuthCubit>().state.isAuthenticated;

                if (isAuthenticated) {
                  getIt<SynchAppDatabase>().sync();
                }
              },
              child: screens.elementAt(
                MainNavigationPageState.values.indexOf(state),
              ),
            ),
            bottomNavigationBar: LedgerBottomNav(
              selected: state,
              onSelect: cubit.updateIndex,
              onAdd: () => showQuickAddSheet(context),
              addLabel: LocaleKeys.addTransaction.tr(),
              items: [
                LedgerNavItem(
                  icon: LucideIcons.house,
                  label: LocaleKeys.home.tr(),
                  state: MainNavigationPageState.values[0],
                ),
                LedgerNavItem(
                  icon: LucideIcons.chartNoAxesColumn,
                  label: LocaleKeys.statistics.tr(),
                  state: MainNavigationPageState.values[1],
                ),
                LedgerNavItem(
                  icon: LucideIcons.wallet,
                  label: LocaleKeys.wallets.tr(),
                  state: MainNavigationPageState.values[2],
                ),
                LedgerNavItem(
                  icon: LucideIcons.target,
                  label: LocaleKeys.drawerBudgets.tr(),
                  state: MainNavigationPageState.values[3],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
