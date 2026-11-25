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
import 'package:trakli/presentation/ai_chat/widgets/trakli_menu_glyph.dart';
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
    final defaultGroupId = configState
        .getConfigByKey(ConfigConstants.defaultGroup)
        ?.value as String?;
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
      titleWidget: const Align(
        alignment: Alignment.centerLeft,
        child: _DrawerMark(),
      ),
      actions: [
        LedgerIconButton(
          icon: LucideIcons.bell,
          tooltip: LocaleKeys.notifications.tr(),
          onTap: () => AppNavigator.push(context, const NotificationsScreen()),
        ),
        const _AccountMenu(),
      ],
    );
  }
}

class _DrawerMark extends StatelessWidget {
  const _DrawerMark();

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Semantics(
      button: true,
      label: LocaleKeys.homeMenu.tr(),
      child: Tooltip(
        message: LocaleKeys.homeMenu.tr(),
        child: Material(
          key: const ValueKey('home-drawer-mark'),
          color: t.bgSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.sm),
            side: BorderSide(color: t.borderLight),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => scaffoldKey.currentState?.openDrawer(),
            child: SizedBox(
              width: 32.lx,
              height: 32.lx,
              child: const Center(child: TrakliMenuGlyph()),
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountMenu extends StatelessWidget {
  const _AccountMenu();

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final spaceCubit = context.watch<SpaceCubit?>();
    final spaceState = spaceCubit?.state;

    Widget spaceItem({
      required IconData icon,
      required String label,
      required bool active,
      required VoidCallback onPressed,
    }) =>
        MenuItemButton(
          leadingIcon: Icon(icon, size: 16.lx, color: t.textSecondary),
          trailingIcon: active
              ? Icon(LucideIcons.check, size: 16.lx, color: t.brandText)
              : null,
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5.lx,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );

    return MenuAnchor(
      alignmentOffset: Offset(0, 4.lx),
      onOpen: () => spaceCubit?.loadSpaces(),
      style: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(t.bgSurface),
        side: WidgetStatePropertyAll(BorderSide(color: t.borderLight)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
      ),
      menuChildren: [
        MenuItemButton(
          leadingIcon:
              Icon(LucideIcons.user, size: 16.lx, color: t.textSecondary),
          onPressed: () => AppNavigator.push(context, const ProfileScreen()),
          child: Text(
            LocaleKeys.profile.tr(),
            style: TextStyle(fontSize: 13.5.lx),
          ),
        ),
        if (spaceCubit != null && spaceState != null) ...[
          const Divider(height: 1),
          Padding(
            padding: EdgeInsets.fromLTRB(12.lx, 10.lx, 12.lx, 4.lx),
            child: LedgerH6(LocaleKeys.homeSwitchSpace.tr()),
          ),
          spaceItem(
            icon: LucideIcons.user,
            label: LocaleKeys.spacePersonal.tr(),
            active: spaceState.isPersonal,
            onPressed: () {
              if (!spaceState.isPersonal) spaceCubit.switchTo(null);
            },
          ),
          for (final space in spaceState.spaces)
            spaceItem(
              icon: LucideIcons.users,
              label: space.name,
              active: spaceState.activeSlug == space.slug,
              onPressed: () {
                if (spaceState.activeSlug != space.slug) {
                  spaceCubit.switchTo(space.slug);
                }
              },
            ),
          MenuItemButton(
            leadingIcon: Icon(
              LucideIcons.settings2,
              size: 16.lx,
              color: t.textSecondary,
            ),
            onPressed: () => showSpaceSwitcherSheet(context),
            child: Text(
              LocaleKeys.homeManageSpaces.tr(),
              style: TextStyle(fontSize: 13.5.lx),
            ),
          ),
        ],
      ],
      builder: (context, controller, _) => LedgerIconButton(
        key: const ValueKey('home-account-menu'),
        icon: LucideIcons.userRound,
        tooltip: LocaleKeys.profile.tr(),
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
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

    final months = transactionsByMonth(
      transactions,
      currency: currency.code,
      rates: currency.rates,
    );
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
                    subtitle:
                        (b.reminder.description?.trim().isNotEmpty ?? false)
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
        SizedBox(height: 16.lx),
        LedgerH6(
          LocaleKeys.homeRecent.tr(),
          actionLabel: LocaleKeys.seeAll.tr(),
          onAction: () => AppNavigator.push(context, const ActivityScreen()),
        ),
        for (final (i, m) in months.indexed) ...[
          SizedBox(height: 8.lx),
          _MonthCard(
            key: ValueKey(m.month),
            month: m,
            label: DateFormat.yMMMM(locale).format(m.month),
            currency: currency.code,
            initiallyExpanded: i == 0,
          ),
        ],
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
                            color:
                                main ? t.onBrand.withValues(alpha: 0.88) : fg,
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

class _MonthCard extends StatefulWidget {
  final HomeMonth month;
  final String label;
  final String currency;
  final bool initiallyExpanded;

  const _MonthCard({
    super.key,
    required this.month,
    required this.label,
    required this.currency,
    required this.initiallyExpanded,
  });

  @override
  State<_MonthCard> createState() => _MonthCardState();
}

class _MonthCardState extends State<_MonthCard> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final txs = widget.month.transactions;
    final net = widget.month.net;
    return LedgerCard(
      padding: EdgeInsets.fromLTRB(12.lx, 2.lx, 12.lx, 2.lx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.lx),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 13.5.lx,
                        fontWeight: FontWeight.w600,
                        color: t.textPrimary,
                      ),
                    ),
                  ),
                  LedgerAmount(
                    LedgerMoney.format(net, widget.currency, sign: true),
                    weight: FontWeight.w600,
                    color: net >= 0 ? t.incomeColor : t.expenseColor,
                  ),
                  SizedBox(width: 6.lx),
                  Icon(
                    _expanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                    size: 16.lx,
                    color: t.textMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            for (final tx in txs)
              LedgerTransactionRow(
                transaction: tx,
                subtitle: [
                  DateFormat.MMMd(
                          Localizations.localeOf(context).toLanguageTag())
                      .format(tx.transaction.datetime),
                  tx.wallet.name,
                ].join(' · '),
                divider: tx != txs.last,
              ),
        ],
      ),
    );
  }
}
