// ignore_for_file: implementation_imports
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/src/localization.dart';
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trakli/presentation/utils/theme.dart';

/// Screenshots are written only when LEDGER_SHOTS_DIR is set, so the regular
/// test run stays free of file output.
final String? ledgerShotsDir = Platform.environment['LEDGER_SHOTS_DIR'];

bool get ledgerShotsEnabled => ledgerShotsDir != null;

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final f in files) {
    final bytes = File(f).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

String _pubCache() {
  final env = Platform.environment['PUB_CACHE'];
  if (env != null) return env;
  return '${Platform.environment['HOME']}/.pub-cache';
}

String _flutterRoot() {
  final env = Platform.environment['FLUTTER_ROOT'];
  if (env != null) return env;
  return '${Platform.environment['HOME']}/fvm/versions/3.38.9';
}

Future<void> loadLedgerFonts() async {
  await _loadFont('Geist', [
    'assets/fonts/Geist-Regular.ttf',
    'assets/fonts/Geist-Medium.ttf',
    'assets/fonts/Geist-SemiBold.ttf',
    'assets/fonts/Geist-Bold.ttf',
    'assets/fonts/Geist-ExtraBold.ttf',
  ]);
  await _loadFont('GeistMono', [
    'assets/fonts/GeistMono-Regular.ttf',
    'assets/fonts/GeistMono-Medium.ttf',
    'assets/fonts/GeistMono-SemiBold.ttf',
    'assets/fonts/GeistMono-Bold.ttf',
  ]);
  await _loadFont(
      'BricolageGrotesque', ['assets/fonts/BricolageGrotesque.ttf']);
  final lucide = Directory('${_pubCache()}/hosted/pub.dev')
      .listSync()
      .whereType<Directory>()
      .where((d) => d.path.contains('lucide_icons_flutter-'))
      .map((d) => '${d.path}/assets/lucide.ttf')
      .firstWhere((p) => File(p).existsSync());
  await _loadFont('packages/lucide_icons_flutter/Lucide', [lucide]);
  final material =
      '${_flutterRoot()}/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
  if (File(material).existsSync()) {
    await _loadFont('MaterialIcons', [material]);
  }
}

void loadEnglishTranslations() {
  final map = jsonDecode(File('assets/translations/en.json').readAsStringSync())
      as Map<String, dynamic>;
  Localization.load(const Locale('en'), translations: Translations(map));
}

/// Wraps [child] the way the app does: ScreenUtil on the 390 x 844 canvas and
/// the Ledger theme in the requested brightness.
Widget ledgerApp(Widget child, {required bool dark}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      home: child,
    ),
  );
}

/// Pumps [builder] at phone size in light and dark and writes
/// `<name>-light.png` / `<name>-dark.png` into LEDGER_SHOTS_DIR.
Future<void> captureLedgerShots(
  WidgetTester tester,
  String name,
  Widget Function(bool dark) builder, {
  Future<void> Function(WidgetTester tester)? after,
}) async {
  tester.view.physicalSize = const Size(780, 1688);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  for (final dark in [false, true]) {
    final key = GlobalKey();
    await tester.pumpWidget(
      RepaintBoundary(key: key, child: ledgerApp(builder(dark), dark: dark)),
    );
    await tester.pump(const Duration(milliseconds: 50));
    if (after != null) await after(tester);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.runAsync(() async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory(ledgerShotsDir!)..createSync(recursive: true);
      File('${dir.path}/$name-${dark ? 'dark' : 'light'}.png')
          .writeAsBytesSync(bytes!.buffer.asUint8List());
    });
    await tester.pumpWidget(const SizedBox.shrink());
  }
}
