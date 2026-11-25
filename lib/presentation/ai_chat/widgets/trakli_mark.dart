import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';

/// The Trakli mark: green and orange on light surfaces, white and orange on
/// dark ones.
class TrakliMark extends StatelessWidget {
  final double height;
  const TrakliMark({super.key, this.height = 20});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      dark ? Assets.images.appLogo : Assets.images.appLogoGreen,
      height: height.lx,
    );
  }
}

/// The Trakli wordmark, mark included: green on light surfaces, white on
/// dark ones.
class TrakliLogo extends StatelessWidget {
  final double height;
  const TrakliLogo({super.key, this.height = 28});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SvgPicture.asset(
      dark ? Assets.images.logo : Assets.images.logoGreen,
      height: height.lx,
    );
  }
}
