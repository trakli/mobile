import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/statistics/month_in_review/month_in_review_data.dart';
import 'package:trakli/presentation/statistics/statistics_money.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

class RecapPage {
  final String huge;
  final String headline;
  final String? sentence;

  const RecapPage({required this.huge, required this.headline, this.sentence});
}

/// Builds the story pages for a month recap. Pages without data are left
/// out, so a quiet month gets a shorter story.
List<RecapPage> buildRecapPages(
  MonthInReviewData d, {
  required StatsMoney money,
  required String locale,
}) {
  final month = d.month ?? DateTime.now();
  final monthName = DateFormat.MMMM(locale).format(month);
  final dayMonth = DateFormat.MMMMd(locale);
  final pages = <RecapPage>[];

  if (d.net >= 0) {
    pages.add(RecapPage(
      huge: _signed(money, d.net),
      headline: LocaleKeys.recapKeptHeadline.tr(),
      sentence: d.income > 0
          ? LocaleKeys.recapKeptSentence.tr(namedArgs: {
              'rate': (d.savingsRate * 100).round().toString(),
            })
          : null,
    ));
  } else {
    pages.add(RecapPage(
      huge: _signed(money, d.net),
      headline: LocaleKeys.recapOverspentHeadline.tr(),
      sentence: LocaleKeys.recapOverspentSentence.tr(namedArgs: {
        'income': money.short(d.income),
        'spent': money.short(d.expense),
      }),
    ));
  }

  if (d.income > 0) {
    pages.add(RecapPage(
      huge: money.short(d.income),
      headline: LocaleKeys.recapInHeadline.tr(),
      sentence: LocaleKeys.recapInSentence.tr(namedArgs: {'month': monthName}),
    ));
  }

  if (d.expense > 0) {
    pages.add(RecapPage(
      huge: money.short(d.expense),
      headline: LocaleKeys.recapOutHeadline.tr(),
      sentence: d.topCategory == null
          ? null
          : LocaleKeys.recapOutSentence
              .tr(namedArgs: {'category': d.topCategory!.name}),
    ));
  }

  final run = d.longestNoSpendRun;
  if (run != null && run.days >= 2) {
    pages.add(RecapPage(
      huge: LocaleKeys.recapDays.tr(namedArgs: {'count': '${run.days}'}),
      headline: LocaleKeys.recapNoSpendHeadline.tr(),
      sentence: (d.noSpendRunIsYearBest
              ? LocaleKeys.recapNoSpendYearBest
              : LocaleKeys.recapNoSpendMonthBest)
          .tr(namedArgs: {
        'start': dayMonth.format(run.start),
        'end': dayMonth.format(run.end),
      }),
    ));
  }

  final top = d.topCategory;
  if (top != null && d.expense > 0) {
    pages.add(RecapPage(
      huge: '${((top.amount / d.expense) * 100).round()}%',
      headline: LocaleKeys.recapTopHeadline.tr(namedArgs: {'category': top.name}),
      sentence: LocaleKeys.recapTopSentence
          .tr(namedArgs: {'amount': money.full(top.amount)}),
    ));
  }

  final biggest = d.biggestExpense;
  if (biggest != null) {
    final party = biggest.party == 'Anonymous'
        ? LocaleKeys.recapUnknownParty.tr()
        : biggest.party;
    final date = dayMonth.format(biggest.date);
    pages.add(RecapPage(
      huge: money.short(biggest.amount),
      headline: LocaleKeys.recapBiggestHeadline.tr(),
      sentence: biggest.category == null
          ? LocaleKeys.recapBiggestSentence
              .tr(namedArgs: {'party': party, 'date': date})
          : LocaleKeys.recapBiggestSentenceCategory.tr(namedArgs: {
              'party': party,
              'category': biggest.category!,
              'date': date,
            }),
    ));
  }

  if (d.transactionCount > 0) {
    final perDay = d.transactionCount / d.daysInMonth;
    pages.add(RecapPage(
      huge: '${d.transactionCount}',
      headline: LocaleKeys.recapEntriesHeadline.tr(),
      sentence: perDay >= 1
          ? LocaleKeys.recapEntriesSentenceDaily
              .tr(namedArgs: {'count': '${perDay.round()}'})
          : LocaleKeys.recapEntriesSentence.tr(namedArgs: {
              'days': '${math.max(1, (1 / perDay).round())}',
            }),
    ));
  }
  return pages;
}

String _signed(StatsMoney money, double v) =>
    v > 0 ? '+${money.short(v)}' : money.short(v);

/// Tap-through month recap: brand-green story pages with a progress strip,
/// tap left or right to move, hold to pause, and a share button.
class MonthInReviewScreen extends StatefulWidget {
  final MonthInReviewData data;
  final int initialPage;
  final bool autoAdvance;

  const MonthInReviewScreen({
    super.key,
    required this.data,
    this.initialPage = 0,
    this.autoAdvance = true,
  });

  static Future<void> show(BuildContext context, MonthInReviewData data) {
    return Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, __, ___) => MonthInReviewScreen(data: data),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  State<MonthInReviewScreen> createState() => _MonthInReviewScreenState();
}

class _MonthInReviewScreenState extends State<MonthInReviewScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _pageDuration = Duration(milliseconds: 6500);

  late final AnimationController _progress;
  late int _index = widget.initialPage;
  List<RecapPage> _pages = const [];

  @override
  void initState() {
    super.initState();
    _progress = AnimationController(vsync: this, duration: _pageDuration)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _next();
      });
    if (widget.autoAdvance) _progress.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pages = buildRecapPages(
      widget.data,
      money: StatsMoney.of(context),
      locale: Localizations.localeOf(context).toString(),
    );
    if (_index >= _pages.length) _index = math.max(0, _pages.length - 1);
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _restart() {
    _progress.reset();
    if (widget.autoAdvance) _progress.forward();
  }

  void _next() {
    if (_index >= _pages.length - 1) {
      Navigator.of(context).maybePop();
      return;
    }
    setState(() => _index++);
    _restart();
  }

  void _prev() {
    if (_index > 0) setState(() => _index--);
    _restart();
  }

  Future<void> _share() async {
    final money = StatsMoney.of(context);
    final d = widget.data;
    final month = DateFormat.MMMM(Localizations.localeOf(context).toString())
        .format(d.month ?? DateTime.now());
    await Share.share(LocaleKeys.recapShareText.tr(namedArgs: {
      'month': month,
      'in': money.short(d.income),
      'out': money.short(d.expense),
      'kept': money.short(d.net),
    }));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final month = DateFormat.MMMM(Localizations.localeOf(context).toString())
        .format(widget.data.month ?? DateTime.now());
    final page = _pages.isEmpty ? null : _pages[_index];
    const ink = Colors.white;

    return Scaffold(
      backgroundColor: t.brandFill,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _prev,
                      onLongPressStart: (_) => _progress.stop(),
                      onLongPressEnd: (_) {
                        if (widget.autoAdvance) _progress.forward();
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _next,
                      onLongPressStart: (_) => _progress.stop(),
                      onLongPressEnd: (_) {
                        if (widget.autoAdvance) _progress.forward();
                      },
                    ),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.lx, 22.lx, 20.lx, 24.lx),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (_, __) => Row(
                        children: [
                          for (var i = 0; i < _pages.length; i++) ...[
                            if (i > 0) SizedBox(width: 3.lx),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(1),
                                child: LinearProgressIndicator(
                                  minHeight: 3.lx,
                                  value: i < _index
                                      ? 1
                                      : (i == _index
                                          ? (widget.autoAdvance
                                              ? _progress.value
                                              : 1)
                                          : 0),
                                  color: ink,
                                  backgroundColor:
                                      ink.withValues(alpha: 0.3),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    Opacity(
                      opacity: 0.85,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            Assets.images.appLogo,
                            height: 16.lx,
                            colorFilter:
                                const ColorFilter.mode(ink, BlendMode.srcIn),
                          ),
                          SizedBox(width: 8.lx),
                          Text(
                            LocaleKeys.recapYour
                                .tr(namedArgs: {'month': month})
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 11.lx,
                              letterSpacing: 0.12 * 11.lx,
                              color: ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    if (page != null) ...[
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          page.huge,
                          maxLines: 1,
                          style: LedgerText.display(
                            size: 58.lx,
                            color: ink,
                            height: 1,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.lx),
                      Text(
                        page.headline,
                        style: LedgerText.display(size: 30.lx, color: ink),
                      ),
                    ],
                    const Spacer(flex: 3),
                    if (page?.sentence != null)
                      Opacity(
                        opacity: 0.9,
                        child: Text(
                          page!.sentence!,
                          style: TextStyle(
                            fontSize: 14.lx,
                            height: 1.5,
                            color: ink,
                          ),
                        ),
                      ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 34.lx,
              right: 12.lx,
              child: IconButton(
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => Navigator.of(context).maybePop(),
                icon: Icon(LucideIcons.x, color: ink, size: 20.lx),
              ),
            ),
            Positioned(
              left: 20.lx,
              right: 20.lx,
              bottom: 24.lx,
              child: Material(
                color: ink,
                borderRadius: BorderRadius.circular(AppRadii.sm),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  onTap: _share,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.lx),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.share2, size: 15.lx, color: t.brandFill),
                        SizedBox(width: 6.lx),
                        Text(
                          LocaleKeys.share.tr(),
                          style: TextStyle(
                            fontSize: 13.lx,
                            fontWeight: FontWeight.w600,
                            color: t.brandFill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
