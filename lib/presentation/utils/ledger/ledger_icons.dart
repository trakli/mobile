import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/widgets/image_widget.dart';

/// Stored category and group icons are icon-set names chosen in the icon
/// picker. They are drawn with the matching outline glyph so lists keep one
/// stroke style; names without an equivalent fall back to [LucideIcons.tag].
const Map<String, IconData> _byName = {
  'academicCap': LucideIcons.graduationCap,
  'archiveBox': LucideIcons.archive,
  'arrowPath': LucideIcons.repeat,
  'arrowTrendingUp': LucideIcons.trendingUp,
  'arrowTrendingDown': LucideIcons.trendingDown,
  'arrowUturnLeft': LucideIcons.rotateCcw,
  'arrowsRightLeft': LucideIcons.arrowLeftRight,
  'banknotes': LucideIcons.banknote,
  'beaker': LucideIcons.flaskConical,
  'bell': LucideIcons.bell,
  'bolt': LucideIcons.plugZap,
  'bookOpen': LucideIcons.bookOpen,
  'briefcase': LucideIcons.briefcase,
  'bugAnt': LucideIcons.bug,
  'buildingLibrary': LucideIcons.landmark,
  'buildingOffice': LucideIcons.building,
  'buildingOffice2': LucideIcons.building2,
  'buildingStorefront': LucideIcons.store,
  'cake': LucideIcons.utensils,
  'calculator': LucideIcons.calculator,
  'calendar': LucideIcons.calendar,
  'calendarDays': LucideIcons.calendarDays,
  'camera': LucideIcons.camera,
  'chartBar': LucideIcons.chartColumn,
  'chartPie': LucideIcons.chartPie,
  'creditCard': LucideIcons.creditCard,
  'computerDesktop': LucideIcons.monitor,
  'currencyDollar': LucideIcons.dollarSign,
  'currencyEuro': LucideIcons.euro,
  'devicePhoneMobile': LucideIcons.smartphone,
  'documentText': LucideIcons.fileText,
  'envelope': LucideIcons.mail,
  'film': LucideIcons.film,
  'fire': LucideIcons.flame,
  'flag': LucideIcons.flag,
  'folder': LucideIcons.folder,
  'gift': LucideIcons.gift,
  'giftTop': LucideIcons.gift,
  'globeAlt': LucideIcons.globe,
  'handRaised': LucideIcons.hand,
  'heart': LucideIcons.heart,
  'home': LucideIcons.house,
  'homeModern': LucideIcons.house,
  'key': LucideIcons.key,
  'lightBulb': LucideIcons.lightbulb,
  'map': LucideIcons.map,
  'mapPin': LucideIcons.mapPin,
  'megaphone': LucideIcons.megaphone,
  'musicalNote': LucideIcons.music,
  'newspaper': LucideIcons.newspaper,
  'paintBrush': LucideIcons.paintbrush,
  'paperAirplane': LucideIcons.send,
  'pencil': LucideIcons.penTool,
  'phone': LucideIcons.phone,
  'photo': LucideIcons.image,
  'puzzlePiece': LucideIcons.puzzle,
  'receiptPercent': LucideIcons.receipt,
  'receiptRefund': LucideIcons.receipt,
  'rocketLaunch': LucideIcons.rocket,
  'scale': LucideIcons.scale,
  'scissors': LucideIcons.scissors,
  'shieldCheck': LucideIcons.shieldCheck,
  'shoppingBag': LucideIcons.shoppingBag,
  'shoppingCart': LucideIcons.shoppingBasket,
  'sparkles': LucideIcons.sparkles,
  'star': LucideIcons.star,
  'sun': LucideIcons.sun,
  'tag': LucideIcons.tag,
  'ticket': LucideIcons.ticket,
  'trophy': LucideIcons.trophy,
  'truck': LucideIcons.bus,
  'tv': LucideIcons.tv,
  'user': LucideIcons.userRound,
  'userGroup': LucideIcons.users,
  'users': LucideIcons.users,
  'wallet': LucideIcons.wallet,
  'wifi': LucideIcons.wifi,
  'wrench': LucideIcons.wrench,
  'wrenchScrewdriver': LucideIcons.wrench,
};

IconData ledgerIconForName(String? name, {IconData fallback = LucideIcons.tag}) {
  if (name == null) return fallback;
  return _byName[name] ?? fallback;
}

IconData ledgerWalletIcon(WalletType type) => switch (type) {
      WalletType.bank => LucideIcons.landmark,
      WalletType.cash => LucideIcons.banknote,
      WalletType.creditCard => LucideIcons.creditCard,
      WalletType.mobile => LucideIcons.smartphone,
    };

/// Draws a stored icon (named icon, emoji or image) at Ledger sizing.
class LedgerMediaIcon extends StatelessWidget {
  final MediaEntity? media;
  final IconData fallback;
  final double size;
  final Color? color;

  const LedgerMediaIcon({
    super.key,
    required this.media,
    this.fallback = LucideIcons.tag,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final m = media;
    final c = color ?? IconTheme.of(context).color;
    if (m == null || m.mediaType == MediaType.icon) {
      return Icon(
        ledgerIconForName(m?.content, fallback: fallback),
        size: size.lx,
        color: c,
      );
    }
    return SizedBox(
      width: size.lx,
      height: size.lx,
      child: FittedBox(
        child: ImageWidget(
          mediaEntity: m,
          accentColor: c,
          iconSize: size.lx,
          emojiSize: size.lx * 0.9,
          placeholderIcon: fallback,
        ),
      ),
    );
  }
}
