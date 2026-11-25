import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/notifications/cubit/notification_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_empty.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/notification_tile.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationCubit>()..loadNotifications(),
      child: Scaffold(
        backgroundColor: context.tones.bgPage,
        appBar: PageAppBar(title: LocaleKeys.notifications.tr()),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            final items = state.notifications;
            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<NotificationCubit>().loadNotifications(),
              child: items.isEmpty
                  ? LedgerEmptyState(
                      loading: state.isLoading,
                      icon: LucideIcons.bell,
                      title: LocaleKeys.noNotifications.tr(),
                    )
                  : ListView(
                      padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
                      children: [
                        LedgerCard(
                          padding: EdgeInsets.symmetric(horizontal: 12.lx),
                          child: Column(
                            children: [
                              for (final (i, n) in items.indexed) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    color: context.tones.borderLight,
                                  ),
                                NotificationTile(notification: n),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
