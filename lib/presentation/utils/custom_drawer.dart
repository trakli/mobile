import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/groups/my_groups_screen.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/parties/party_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/settings_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/premium_tile.dart';
import 'package:trakli/presentation/widgets/database_viewer.dart';

const String _supportEmail = 'support@trakli.app';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _launchSupportEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {
        'subject': 'Trakli Support Request',
      },
    );

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        await _copyEmailAndShowSnackbar(context);
      }
    } catch (e) {
      if (context.mounted) {
        await _copyEmailAndShowSnackbar(context);
      }
    }
  }

  Future<void> _copyEmailAndShowSnackbar(BuildContext context) async {
    await Clipboard.setData(const ClipboardData(text: _supportEmail));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('$_supportEmail (copied to clipboard)'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.sp),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: SvgPicture.asset(
                Assets.images.logoGreen,
                height: 44.sp,
              ),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const CategoryScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.category,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.categories.tr()),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const MyGroupsScreen());
              },
              leading: const Icon(
                Icons.folder_outlined,
                color: Color(0XFF3B4E45),
              ),
              title: Text(LocaleKeys.groups.tr()),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const PartyScreen());
              },
              leading: const Icon(
                Icons.handshake_outlined,
                color: Color(0XFF3B4E45),
              ),
              title: Text(LocaleKeys.parties.tr()),
            ),
            ListTile(
              onTap: () {
                final cubit = context.read<MainNavigationCubit>();
                cubit.updateIndex(MainNavigationPageState.wallet);
                AppNavigator.pop(context);
              },
              leading: SvgPicture.asset(
                Assets.images.wallet,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.wallets.tr()),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const HistoryScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.refresh,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.history.tr()),
            ),
            const Divider(),
            ListTile(
              onTap: () => _launchSupportEmail(context),
              leading: SvgPicture.asset(
                Assets.images.support,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.support.tr()),
            ),
            ListTile(
              onTap: () {
                AppNavigator.push(context, const SettingsScreen());
              },
              leading: SvgPicture.asset(
                Assets.images.setting,
                colorFilter: const ColorFilter.mode(
                  Color(0XFF3B4E45),
                  BlendMode.srcIn,
                ),
              ),
              title: Text(LocaleKeys.settings.tr()),
            ),
            if (kDebugMode) ...[
              const Divider(),
              ListTile(
                onTap: () {
                  AppNavigator.push(
                    context,
                    DatabaseViewer(database: getIt()),
                  );
                },
                leading: const Icon(Icons.storage),
                title: Text(LocaleKeys.databaseViewer.tr()),
              ),
            ],
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: const PremiumTile(),
            ),
          ],
        ),
      ),
    );
  }
}
