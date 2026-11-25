import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/reminders/add_reminder_screen.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/reminders/reminder_labels.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/dialogs.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_empty.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void add() => AppNavigator.push(context, const AddReminderScreen());
    return Scaffold(
      backgroundColor: context.tones.bgPage,
      appBar: PageAppBar(
        title: LocaleKeys.reminders.tr(),
        actions: [
          PageAppBarAction(icon: LucideIcons.plus, primary: true, onTap: add),
        ],
      ),
      body: BlocConsumer<ReminderCubit, ReminderState>(
        listenWhen: (p, c) => p.failure != c.failure && c.failure.hasError,
        listener: (context, state) => showSnackBar(message: state.failure),
        builder: (context, state) {
          final items = state.reminders;
          if (items.isEmpty) {
            return LedgerEmptyState(
              icon: LucideIcons.alarmClock,
              title: LocaleKeys.noReminders.tr(),
              actionLabel: LocaleKeys.addReminder.tr(),
              onAction: add,
            );
          }
          return ListView(
            padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
            children: [
              LedgerCard(
                padding: EdgeInsets.symmetric(horizontal: 12.lx),
                child: Column(
                  children: [
                    for (final r in items)
                      _ReminderTile(reminder: r, divider: r != items.last),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({required this.reminder, required this.divider});

  final ReminderEntity reminder;
  final bool divider;

  IconData get _statusIcon {
    if (reminder.isSnoozed) return LucideIcons.alarmClockOff;
    if (reminder.isPaused) return LucideIcons.bellOff;
    return LucideIcons.bell;
  }

  /// Same dimming as the web reminder cards (paused 0.7, completed 0.5).
  double get _opacity {
    if (reminder.isPaused) return 0.7;
    if (reminder.status == ReminderStatus.completed) return 0.5;
    return 1;
  }

  String get _statusLabel {
    if (reminder.isSnoozed && reminder.snoozedUntil != null) {
      return LocaleKeys.reminderSnoozedUntil.tr(args: [
        DateFormat('dd/MM/yyyy HH:mm').format(reminder.snoozedUntil!.toLocal()),
      ]);
    }
    return reminderStatusLabel(reminder.status);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReminderCubit>();
    final next = reminder.nextTriggerAt ?? reminder.triggerAt;
    final repeat = reminderRepeatLabel(reminder.repeatRule);
    final subtitle = [
      reminderTypeLabel(reminder.type),
      if (next != null) DateFormat('dd/MM/yyyy HH:mm').format(next.toLocal()),
      if (repeat != null) repeat,
      _statusLabel,
    ].join(' · ');

    final t = context.tones;
    return Opacity(
      opacity: _opacity,
      child: LedgerRow(
        leading: LedgerCoin(icon: _statusIcon),
        title: reminder.title,
        subtitleWidget: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12.lx, height: 1.4, color: t.textMuted),
        ),
        divider: divider,
        onTap: () =>
            AppNavigator.push(context, AddReminderScreen(reminder: reminder)),
        trailing: PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          icon: Icon(
            LucideIcons.ellipsisVertical,
            size: 16.lx,
            color: t.textMuted,
          ),
          onSelected: (value) => _onAction(context, cubit, value),
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text(LocaleKeys.edit.tr())),
            if (reminder.isPaused)
              PopupMenuItem(
                  value: 'resume', child: Text(LocaleKeys.resume.tr()))
            else
              PopupMenuItem(value: 'pause', child: Text(LocaleKeys.pause.tr())),
            if (reminder.isSnoozed)
              PopupMenuItem(
                value: 'removeSnooze',
                child: Text(LocaleKeys.removeSnooze.tr()),
              )
            else
              PopupMenuItem(
                  value: 'snooze', child: Text(LocaleKeys.snooze.tr())),
            PopupMenuItem(
              value: 'delete',
              child: Text(
                LocaleKeys.delete.tr(),
                style: TextStyle(color: t.expenseColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _snooze(BuildContext context, ReminderCubit cubit) async {
    final choice = await showLedgerOptionsSheet<Object>(
      context,
      title: LocaleKeys.snoozeUntil.tr(),
      options: [
        for (final (label, duration) in <(String, Duration)>[
          (LocaleKeys.snoozeOneHour.tr(), const Duration(hours: 1)),
          (LocaleKeys.snoozeTwoHours.tr(), const Duration(hours: 2)),
          (LocaleKeys.snoozeTomorrow.tr(), const Duration(days: 1)),
          (LocaleKeys.snoozeNextWeek.tr(), const Duration(days: 7)),
        ])
          LedgerOption<Object>(duration, label),
        LedgerOption<Object>('custom', LocaleKeys.snoozeCustom.tr()),
      ],
    );
    if (choice == null || !context.mounted) return;

    DateTime? until;
    if (choice is Duration) {
      until = DateTime.now().add(choice);
    } else {
      until = await _pickCustomUntil(context);
    }
    if (until == null) return;

    await cubit.snooze(reminder.clientId, until.toUtc());
    if (!cubit.state.failure.hasError) {
      showSnackBar(
        message: LocaleKeys.reminderSnoozedUntil
            .tr(args: [DateFormat('dd/MM/yyyy HH:mm').format(until)]),
        isSuccess: true,
      );
    }
  }

  Future<DateTime?> _pickCustomUntil(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    return DateTime(
      date.year,
      date.month,
      date.day,
      time?.hour ?? 9,
      time?.minute ?? 0,
    );
  }

  Future<void> _onAction(
    BuildContext context,
    ReminderCubit cubit,
    String value,
  ) async {
    switch (value) {
      case 'edit':
        AppNavigator.push(context, AddReminderScreen(reminder: reminder));
        break;
      case 'pause':
        cubit.pause(reminder.clientId);
        break;
      case 'resume':
      case 'removeSnooze':
        cubit.resume(reminder.clientId);
        break;
      case 'snooze':
        _snooze(context, cubit);
        break;
      case 'delete':
        final ok = await showDeleteConfirmationDialog(
          context,
          title: LocaleKeys.deleteReminder.tr(),
          message: LocaleKeys.deleteReminderConfirmation.tr(),
        );
        if (ok) cubit.deleteReminder(reminder.clientId);
        break;
    }
  }
}
