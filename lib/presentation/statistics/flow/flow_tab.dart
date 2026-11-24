import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/statistics/flow/flow_data.dart';
import 'package:trakli/presentation/statistics/statistics_money.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_money.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class StatisticsFlowTab extends StatefulWidget {
  final DateTime month;

  const StatisticsFlowTab({super.key, required this.month});

  @override
  State<StatisticsFlowTab> createState() => _StatisticsFlowTabState();
}

class _StatisticsFlowTabState extends State<StatisticsFlowTab> {
  String? _picked;

  Future<void> _open(
    FlowNode node,
    FlowData data,
    List<TransactionCompleteEntity> transactions,
    StatsMoney money,
  ) async {
    if (node.type == FlowNodeType.shortfall) return;
    setState(() => _picked = node.key);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.tones.bgSurface,
      builder: (_) => _FlowStreamSheet(
        node: node,
        data: data,
        transactions: transactions,
        money: money,
      ),
    );
    if (mounted) setState(() => _picked = null);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final transactions = context.watch<TransactionCubit>().state.transactions;
    final money = StatsMoney.of(context);
    final data = buildFlowData(
      transactions,
      month: widget.month,
      convert: money.convert,
      uncategorizedLabel: LocaleKeys.statsFlowUncategorized.tr(),
      otherLabel: LocaleKeys.statsFlowOther.tr(),
      keptLabel: LocaleKeys.statsFlowKept.tr(),
      shortfallLabel: LocaleKeys.statsFlowShortfall.tr(),
    );
    final monthName = DateFormat.MMMM(Localizations.localeOf(context).toString());
    final previous = DateTime(widget.month.year, widget.month.month - 1);

    return ListView(
      padding: EdgeInsets.fromLTRB(14.lx, 0, 14.lx, 120.lx),
      children: [
        LedgerCard(
          padding: EdgeInsets.all(8.lx),
          child: data.isEmpty
              ? SizedBox(
                  height: 120.lx,
                  child: Center(
                    child: Text(
                      LocaleKeys.statsFlowEmpty.tr(namedArgs: {
                        'month': monthName.format(widget.month),
                      }),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                    ),
                  ),
                )
              : FlowSankey(
                  data: data,
                  picked: _picked,
                  height: 250.lx,
                  onTap: (node) => _open(node, data, transactions, money),
                ),
        ),
        SizedBox(height: 12.lx),
        Row(
          children: [
            Expanded(
              child: _Total(
                label: LocaleKeys.statsFlowIn.tr(),
                value: money.short(data.totalIn),
                color: t.incomeColor,
              ),
            ),
            SizedBox(width: 6.lx),
            Expanded(
              child: _Total(
                label: LocaleKeys.statsFlowOut.tr(),
                value: money.short(data.totalOut),
                color: t.textPrimary,
              ),
            ),
            SizedBox(width: 6.lx),
            Expanded(
              child: _Total(
                label: LocaleKeys.statsFlowKept.tr(),
                value: money.short(data.kept),
                color: data.kept >= 0 ? t.incomeColor : t.expenseColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.lx),
        LedgerCard(
          padding: EdgeInsets.symmetric(horizontal: 12.lx, vertical: 10.lx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LedgerH6(LocaleKeys.statsFlowTapTitle.tr()),
              SizedBox(height: 4.lx),
              Text(
                LocaleKeys.statsFlowTapBody.tr(namedArgs: {
                  'month': monthName.format(previous),
                }),
                style: TextStyle(
                  fontSize: 12.5.lx,
                  height: 1.4,
                  color: t.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Total extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Total({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return LedgerCard(
      padding: EdgeInsets.all(8.lx),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11.lx, color: context.tones.textMuted),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: LedgerAmount(
              value,
              size: 14,
              weight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _Rect {
  final FlowNode node;
  final Rect rect;
  const _Rect(this.node, this.rect);
}

class _Layout {
  final List<_Rect> sources;
  final List<_Rect> sinks;
  final Rect mid;
  const _Layout(this.sources, this.sinks, this.mid);
}

/// Money-flow diagram: income streams flow into a middle bar that fans out
/// into spending streams and what was kept. Tapping a stream reports its
/// node through [onTap].
class FlowSankey extends StatelessWidget {
  final FlowData data;
  final String? picked;
  final double height;
  final ValueChanged<FlowNode>? onTap;

  const FlowSankey({
    super.key,
    required this.data,
    required this.height,
    this.picked,
    this.onTap,
  });

  static _Layout _layoutFor(FlowData data, Size size, double labelRoom) {
    final w = size.width;
    final h = size.height;
    final nw = 8.lx;
    final top = 6.lx;
    final gap = 4.lx;
    final left = 6.lx;
    final through = data.through <= 0 ? 1.0 : data.through;
    final sinks = data.sinks;
    final k = (h - top * 2 - gap * (sinks.length - 1).clamp(0, 99)) / through;
    final midH = through * k;
    final midY = (h - midH) / 2;
    final xm = w / 2 - nw / 2;
    final x1 = w - labelRoom - nw;

    final lg = gap * 3;
    final srcCount = data.sources.length;
    var ly = (h - (through * k + lg * (srcCount - 1).clamp(0, 99))) / 2;
    final src = <_Rect>[];
    for (final n in data.sources) {
      final nh = n.amount * k;
      src.add(_Rect(n, Rect.fromLTWH(left, ly, nw, nh)));
      ly += nh + lg;
    }
    var ry = top;
    final out = <_Rect>[];
    for (final n in sinks) {
      final nh = n.amount * k;
      out.add(_Rect(n, Rect.fromLTWH(x1, ry, nw, nh)));
      ry += nh + gap;
    }
    return _Layout(src, out, Rect.fromLTWH(xm, midY, nw, midH));
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final labelRoom = 92.lx;
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, c) {
          final size = Size(c.maxWidth, height);
          final l = _layoutFor(data, size, labelRoom);
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: onTap == null
                ? null
                : (d) {
                    final p = d.localPosition;
                    final list = p.dx < size.width / 2 ? l.sources : l.sinks;
                    for (final r in list) {
                      final band = Rect.fromLTRB(
                        p.dx < size.width / 2 ? 0 : l.mid.right,
                        r.rect.top - 2,
                        p.dx < size.width / 2 ? l.mid.left : size.width,
                        r.rect.bottom + 2,
                      );
                      if (band.contains(p)) {
                        onTap!(r.node);
                        return;
                      }
                    }
                  },
            child: CustomPaint(
              size: size,
              painter: _SankeyPainter(
                layout: l,
                picked: picked,
                labelStyle: TextStyle(
                  fontFamily: AppFonts.body,
                  fontSize: 10.5.lx,
                  color: t.textSecondary,
                ),
                band: t.textMuted,
                brand: t.brandText,
                sinkNode: t.textSecondary,
                midNode: t.textPrimary,
                pick: t.accentWarm,
                labelGap: 7.lx,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SankeyPainter extends CustomPainter {
  final _Layout layout;
  final String? picked;
  final TextStyle labelStyle;
  final Color band;
  final Color brand;
  final Color sinkNode;
  final Color midNode;
  final Color pick;
  final double labelGap;

  _SankeyPainter({
    required this.layout,
    required this.picked,
    required this.labelStyle,
    required this.band,
    required this.brand,
    required this.sinkNode,
    required this.midNode,
    required this.pick,
    required this.labelGap,
  });

  Path _band(double a, double ya, double b, double yb, double h) {
    final c = (a + b) / 2;
    return Path()
      ..moveTo(a, ya)
      ..cubicTo(c, ya, c, yb, b, yb)
      ..lineTo(b, yb + h)
      ..cubicTo(c, yb + h, c, ya + h, a, ya + h)
      ..close();
  }

  bool _isSourceType(FlowNode n) =>
      n.type == FlowNodeType.income || n.type == FlowNodeType.shortfall;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = layout.mid;
    var mi = mid.top;
    for (final r in layout.sources) {
      final on = r.node.key == picked;
      final color = on
          ? pick.withValues(alpha: 0.7)
          : (r.node.type == FlowNodeType.shortfall
              ? band.withValues(alpha: 0.17)
              : brand.withValues(alpha: 0.24));
      canvas.drawPath(
        _band(r.rect.right, r.rect.top, mid.left, mi, r.rect.height),
        Paint()..color = color,
      );
      mi += r.rect.height;
    }
    var mo = mid.top;
    for (final r in layout.sinks) {
      final on = r.node.key == picked;
      final kept = r.node.type == FlowNodeType.kept;
      final color = on
          ? pick.withValues(alpha: 0.7)
          : (kept
              ? brand.withValues(alpha: 0.36)
              : band.withValues(alpha: 0.17));
      canvas.drawPath(
        _band(mid.right, mo, r.rect.left, r.rect.top, r.rect.height),
        Paint()..color = color,
      );
      mo += r.rect.height;
    }

    RRect node(Rect r) => RRect.fromRectAndRadius(
          Rect.fromLTWH(r.left, r.top, r.width, r.height < 2 ? 2 : r.height),
          const Radius.circular(1),
        );

    for (final r in layout.sources) {
      final on = r.node.key == picked;
      canvas.drawRRect(
        node(r.rect),
        Paint()
          ..color = on
              ? pick
              : (_isSourceType(r.node) &&
                      r.node.type != FlowNodeType.shortfall
                  ? brand
                  : sinkNode),
      );
    }
    canvas.drawRRect(node(mid), Paint()..color = midNode);
    var labelFloor = double.negativeInfinity;
    for (final r in layout.sinks) {
      final on = r.node.key == picked;
      final kept = r.node.type == FlowNodeType.kept;
      canvas.drawRRect(
        node(r.rect),
        Paint()..color = on ? pick : (kept ? brand : sinkNode),
      );
      final tp = TextPainter(
        text: TextSpan(text: r.node.label, style: labelStyle),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
        ellipsis: '\u2026',
      )..layout(maxWidth: size.width - r.rect.right - labelGap);
      final top = r.rect.center.dy - tp.height / 2;
      if (top < labelFloor) continue;
      tp.paint(canvas, Offset(r.rect.right + labelGap, top));
      labelFloor = top + tp.height;
    }
  }

  @override
  bool shouldRepaint(covariant _SankeyPainter old) =>
      old.layout != layout || old.picked != picked || old.band != band;
}

class _FlowStreamSheet extends StatelessWidget {
  final FlowNode node;
  final FlowData data;
  final List<TransactionCompleteEntity> transactions;
  final StatsMoney money;

  const _FlowStreamSheet({
    required this.node,
    required this.data,
    required this.transactions,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final locale = Localizations.localeOf(context).toString();
    final previous = DateTime(data.month.year, data.month.month - 1);
    final previousName = DateFormat.MMMM(locale).format(previous);

    Widget body;
    String? compare;
    if (node.type == FlowNodeType.kept) {
      body = Text(
        LocaleKeys.statsFlowKeptNote.tr(namedArgs: {
          'income': money.full(data.totalIn),
          'spent': money.full(data.totalOut),
        }),
        style: TextStyle(fontSize: 13.lx, height: 1.45, color: t.textSecondary),
      );
    } else {
      final excluded = data.sinks
          .where((s) => s.key != otherKey)
          .map((s) => s.key)
          .toSet();
      final detail = flowStreamDetail(
        transactions,
        key: node.key,
        type: node.type,
        month: data.month,
        convert: money.convert,
        otherExcluded: excluded,
      );
      final diff = detail.total - detail.previousTotal;
      if (detail.previousTotal <= 0) {
        compare = LocaleKeys.statsFlowNoPrevious
            .tr(namedArgs: {'month': previousName});
      } else if (diff.abs() < 0.005) {
        compare =
            LocaleKeys.statsFlowSame.tr(namedArgs: {'month': previousName});
      } else {
        compare = (diff > 0
                ? LocaleKeys.statsFlowMore
                : LocaleKeys.statsFlowLess)
            .tr(namedArgs: {
          'amount': money.full(diff.abs()),
          'month': previousName,
        });
      }
      body = Column(
        children: [
          for (final tx in detail.transactions)
            LedgerRow(
              leading: LedgerCoin(
                icon: LucideIcons.tag,
                media: tx.categories.isEmpty ? null : tx.categories.first.icon,
              ),
              title: tx.transaction.description.isEmpty
                  ? (tx.party?.name ?? node.label)
                  : tx.transaction.description,
              subtitle:
                  '${DateFormat.MMMd(locale).format(tx.transaction.datetime)} · ${tx.wallet.name}',
              trailing: LedgerAmount(
                LedgerMoney.format(
                  tx.transaction.type == TransactionType.income
                      ? tx.transaction.amount
                      : -tx.transaction.amount,
                  tx.wallet.currencyCode,
                  sign: tx.transaction.type == TransactionType.income,
                ),
                color: tx.transaction.type == TransactionType.income
                    ? t.incomeColor
                    : null,
              ),
              divider: tx != detail.transactions.last,
            ),
        ],
      );
    }

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(14.lx, 12.lx, 14.lx, 14.lx),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LedgerSheetHandle(),
              SizedBox(height: 12.lx),
              LedgerH6(
                '${node.label} · ${DateFormat.MMMM(locale).format(data.month)}',
              ),
              SizedBox(height: 6.lx),
              LedgerBigNumber(
                money.full(node.amount),
                size: 28,
                color: node.type == FlowNodeType.expense
                    ? t.textPrimary
                    : t.incomeColor,
              ),
              if (compare != null) ...[
                SizedBox(height: 6.lx),
                Text(
                  compare,
                  style: TextStyle(fontSize: 12.5.lx, color: t.textSecondary),
                ),
              ],
              SizedBox(height: 10.lx),
              body,
            ],
          ),
        ),
      ),
    );
  }
}
