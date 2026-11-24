import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/activity/activity_screen.dart';
import 'package:trakli/presentation/ai_chat/ai_chat_screen.dart';
import 'package:trakli/presentation/ai_chat/widgets/trakli_mark.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/budget/cubit/budget_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/home/home_summary.dart';
import 'package:trakli/presentation/info_interfaces/empty_home_widget.dart';
import 'package:trakli/presentation/notifications/notifications_screen.dart';
import 'package:trakli/presentation/profile_screen.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/reminders/reminder_screen.dart';
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/spaces/space_home_view.dart';
import 'package:trakli/presentation/spaces/space_switcher_sheet.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/ledger_transaction_row.dart';
import 'package:trakli/presentation/transactions/quick_add/quick_add_sheet.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/globals.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_currency.dart';
import 'package:trakli/presentation/utils/ledger/ledger_icons.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/presentation/wallets/wallet_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  /// Fixed clock for tests and screenshots.
  final DateTime? now;

  const HomeScreen({super.key, this.now});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final groups = context.watch<GroupCubit>().state.groups;
    final configState = context.watch<ConfigCubit>().state;
    final defaultGroupId =
        configState.getConfigByKey(ConfigConstants.defaultGroup)?.value
            as String?;
    final defaultGroup =
        groups.firstWhereOrNull((g) => g.clientId == defaultGroupId);
    final txCubit = context.read<TransactionCubit>();
    final selectedGroup =
        context.watch<TransactionCubit>().state.selectedGroup ?? defaultGroup;
    if (txCubit.state.selectedGroup != selectedGroup) {
      txCubit.setCurrentGroup(selectedGroup);
    }

    return Scaffold(
      backgroundColor: t.bgPage,
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<TransactionCubit, TransactionState>(
          listenWhen: (a, b) => a.failure != b.failure,
          listener: (context, state) {
            if (state.failure.hasError) {
              showSnackBar(message: state.failure.customMessage);
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(t.brandFill),
                ),
              );
            }
            final inSpace =
                !(context.watch<SpaceCubit?>()?.state.isPersonal ?? true);
            if (inSpace) return const SpaceHomeView();
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 6.lx),
                  child: const _HomeHeader(),
                ),
                Expanded(
                  child: state.transactions.isEmpty
                      ? const EmptyHomeWidget()
                      : _HomeBody(now: now ?? DateTime.now()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return LedgerScreenBar(
      leadingIcon: LucideIcons.menu,
      onLeading: () => scaffoldKey.currentState?.openDrawer(),
      titleWidget: Align(
        alignment: Alignment.centerLeft,
        child: Semantics(
          button: true,
          label: LocaleKeys.homeSwitchSpace.tr(),
          child: GestureDetector(
            key: const ValueKey('home-space-switcher'),
            behavior: HitTestBehavior.opaque,
            onTap: () => showSpaceSwitcherSheet(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TrakliMark(height: 18),
                SizedBox(width: 4.lx),
                Icon(
                  LucideIcons.chevronDown,
                  size: 14.lx,
                  color: context.tones.textMuted,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        LedgerIconButton(
          icon: LucideIcons.bell,
          tooltip: LocaleKeys.notifications.tr(),
          onTap: () => AppNavigator.push(context, const NotificationsScreen()),
        ),
        const _ProfileSquare(),
      ],
    );
  }
}

class _ProfileSquare extends StatelessWidget {
  const _ProfileSquare();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().state.user;
    final name = [user?.firstName, user?.lastName]
        .whereType<String>()
        .where((s) => s.trim().isNotEmpty)
        .join(' ');
    return Tooltip(
      message: LocaleKeys.profile.tr(),
      child: GestureDetector(
        onTap: () => AppNavigator.push(context, const ProfileScreen()),
        child: LedgerInitials(
          name.isNotEmpty ? name : (user?.email ?? '?'),
          size: 32,
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  final DateTime now;

  const _HomeBody({required this.now});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final transactions = context.watch<TransactionCubit>().state.transactions;
    final wallets = context.watch<WalletCubit>().state.wallets;
    final reminders = context.watch<ReminderCubit>().state.reminders;
    final budgets = context.watch<BudgetCubit>().state.budgets;
    final currency = LedgerCurrency.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();

    final summary = buildHomeSummary(
      transactions,
      now: now,
      currency: currency.code,
      rates: currency.rates,
    );
    final monthName = DateFormat.MMMM(locale).format(summary.month);
    final prevName = DateFormat.MMMM(locale).format(summary.previousMonth);
    final overBudget = budgets.firstWhereOrNull(
      (b) => b.isActive && b.progress?.status == BudgetStatus.overBudget,
    );
    final notes = <String>[
      if (summary.paceDelta != null && summary.paceDelta!.abs() >= 0.005)
        (summary.paceDelta! >= 0
                ? LocaleKeys.homePaceUnder
                : LocaleKeys.homePaceOver)
            .tr(namedArgs: {
          'amount': LedgerMoney.format(summary.paceDelta!.abs(), currency.code),
          'month': prevName,
        }),
      if (overBudget != null)
        LocaleKeys.homeBudgetOver.tr(namedArgs: {'name': overBudget.name}),
    ];

    final today = transactionsOnDay(transactions, now);
    final bills = upcomingBills(reminders, transactions, now: now);

    return ListView(
      padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 24.lx),
      children: [
        Text(
          LocaleKeys.homeKeptIn.tr(namedArgs: {'month': monthName}),
          style: TextStyle(fontSize: 12.lx, color: t.textMuted),
        ),
        SizedBox(height: 4.lx),
        LedgerBigNumber(
          LedgerMoney.format(summary.kept, currency.code, sign: true),
          color: summary.kept >= 0 ? t.incomeColor : t.expenseColor,
        ),
        if (notes.isNotEmpty) ...[
          SizedBox(height: 6.lx),
          Text(
            notes.join(' · '),
            style: TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
          ),
        ],
        SizedBox(height: 12.lx),
        _WalletStrip(wallets: wallets),
        SizedBox(height: 12.lx),
        LedgerAskBar(
          text: LocaleKeys.homeAskHint.tr(),
          trailingIcon: LucideIcons.mic,
          onTap: () => AppNavigator.push(context, const AiChatScreen()),
          onTrailingTap: () => showQuickAddSheet(context),
        ),
        if (bills.isNotEmpty) ...[
          SizedBox(height: 12.lx),
          LedgerCard(
            padding: EdgeInsets.fromLTRB(12.lx, 10.lx, 12.lx, 2.lx),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LedgerH6(LocaleKeys.homeComingUp.tr()),
                for (final b in bills)
                  LedgerRow(
                    leading: LedgerWhen(
                      day: '${b.due.day}',
                      month: DateFormat.MMM(locale).format(b.due),
                    ),
                    title: b.reminder.title,
                    subtitle: (b.reminder.description?.trim().isNotEmpty ?? false)
                        ? b.reminder.description
                        : b.walletName,
                    divider: b != bills.last,
                    onTap: () =>
                        AppNavigator.push(context, const ReminderScreen()),
                    trailing: b.amount == null
                        ? null
                        : LedgerAmount(
                            LedgerMoney.format(b.amount!, b.currency!),
                          ),
                  ),
              ],
            ),
          ),
        ],
        SizedBox(height: 12.lx),
        LedgerCard(
          padding: EdgeInsets.fromLTRB(12.lx, 10.lx, 12.lx, 2.lx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LedgerH6(
                LocaleKeys.homeToday.tr(),
                actionLabel: LocaleKeys.seeAll.tr(),
                onAction: () =>
                    AppNavigator.push(context, const ActivityScreen()),
              ),
              if (today.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.lx),
                  child: Text(
                    LocaleKeys.homeNothingToday.tr(),
                    style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                  ),
                )
              else
                for (final tx in today)
                  LedgerTransactionRow(
                    transaction: tx,
                    divider: tx != today.last,
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletStrip extends StatelessWidget {
  final List<WalletEntity> wallets;

  const _WalletStrip({required this.wallets});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final defaultId = context
        .watch<ConfigCubit>()
        .state
        .getConfigByKey(ConfigConstants.defaultWallet)
        ?.value as String?;
    final ordered = [
      ...wallets.where((w) => w.clientId == defaultId),
      ...wallets.where((w) => w.clientId != defaultId),
    ];
    if (ordered.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 70.lx,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ordered.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.lx),
        itemBuilder: (context, i) {
          final w = ordered[i];
          final main = i == 0;
          final fg = main ? t.onBrand : t.textMuted;
          return SizedBox(
            width: 128.lx,
            child: LedgerCard(
              color: main ? t.brandFill : null,
              borderColor: main ? Colors.transparent : null,
              padding: EdgeInsets.all(10.lx),
              onTap: () =>
                  AppNavigator.push(context, WalletDetailScreen(wallet: w)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      LedgerMediaIcon(
                        media: w.icon,
                        fallback: ledgerWalletIcon(w.type),
                        size: 14,
                        color: main ? t.onBrand : t.textMuted,
                      ),
                      SizedBox(width: 5.lx),
                      Expanded(
                        child: Text(
                          w.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.lx,
                            color: main
                                ? t.onBrand.withValues(alpha: 0.88)
                                : fg,
                          ),
                        ),
                      ),
                    ],
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LedgerMoney.format(w.balance, w.currencyCode),
                      style: LedgerText.money(
                        size: 15.lx,
                        weight: FontWeight.w600,
                        color: main ? t.onBrand : t.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
