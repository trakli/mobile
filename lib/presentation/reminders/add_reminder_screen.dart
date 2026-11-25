import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/reminder_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/reminders/cubit/reminder_cubit.dart';
import 'package:trakli/presentation/reminders/reminder_labels.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_form.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';

///  RRULE values.
const _repeatRules = <String, String?>{
  'none': null,
  'daily': 'FREQ=DAILY',
  'weekly': 'FREQ=WEEKLY',
  'monthly': 'FREQ=MONTHLY',
};

/// Same timezone list to be in sync with the web.
const _timezones = <String, String>{
  'UTC': 'UTC',
  'America/New_York': 'Eastern Time',
  'America/Chicago': 'Central Time',
  'America/Denver': 'Mountain Time',
  'America/Los_Angeles': 'Pacific Time',
  'Europe/London': 'London',
  'Europe/Paris': 'Paris',
  'Asia/Tokyo': 'Tokyo',
};

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key, this.reminder});

  final ReminderEntity? reminder;

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _type = ReminderType.custom;
  int _priority = 0;
  String _timezone = 'UTC';
  String _repeat = 'none';
  DateTime? _triggerAt;

  bool get _isEdit => widget.reminder != null;

  @override
  void initState() {
    super.initState();
    final r = widget.reminder;
    if (r != null) {
      _titleController.text = r.title;
      _descriptionController.text = r.description ?? '';
      _type = r.type;
      _priority = r.priority;
      _timezone = r.timezone ?? 'UTC';
      _repeat = _repeatFromRule(r.repeatRule);
      _triggerAt = r.triggerAt?.toLocal();
    } else {
      _triggerAt = _defaultTriggerAt();
    }
  }

  static DateTime _defaultTriggerAt() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, now.hour + 1);
  }

  static String _repeatFromRule(String? rule) {
    if (rule == null || rule.isEmpty) return 'none';
    if (rule.contains('DAILY')) return 'daily';
    if (rule.contains('WEEKLY')) return 'weekly';
    if (rule.contains('MONTHLY')) return 'monthly';
    return 'none';
  }

  String _repeatLabel(String option) {
    switch (option) {
      case 'daily':
        return LocaleKeys.reminderRepeatDaily.tr();
      case 'weekly':
        return LocaleKeys.reminderRepeatWeekly.tr();
      case 'monthly':
        return LocaleKeys.reminderRepeatMonthly.tr();
      default:
        return LocaleKeys.reminderRepeatNone.tr();
    }
  }

  String _priorityLabel(int priority) {
    switch (priority) {
      case 1:
        return LocaleKeys.reminderPriorityHigh.tr();
      case 2:
        return LocaleKeys.reminderPriorityUrgent.tr();
      default:
        return LocaleKeys.reminderPriorityNormal.tr();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickTrigger(FormFieldState<DateTime> field) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _triggerAt ?? now,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_triggerAt ?? now),
    );
    if (!mounted) return;
    setState(() {
      _triggerAt = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 9,
        time?.minute ?? 0,
      );
    });
    field.didChange(_triggerAt);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ReminderCubit>();
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final repeatRule = _repeatRules[_repeat];
    if (_isEdit) {
      cubit.updateReminder(
        widget.reminder!.clientId,
        title: title,
        description: description,
        type: _type,
        triggerAt: _triggerAt?.toUtc(),
        repeatRule: repeatRule,
        clearRepeatRule: repeatRule == null,
        timezone: _timezone,
        priority: _priority,
      );
    } else {
      cubit.createReminder(
        title: title,
        description: description.isEmpty ? null : description,
        type: _type,
        triggerAt: _triggerAt?.toUtc(),
        repeatRule: repeatRule,
        timezone: _timezone,
        priority: _priority,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final timezones = Map<String, String>.of(_timezones);
    timezones.putIfAbsent(_timezone, () => _timezone);

    return BlocConsumer<ReminderCubit, ReminderState>(
      listenWhen: (p, c) => p.isSaving && !c.isSaving,
      listener: (context, state) {
        if (!state.failure.hasError) Navigator.of(context).pop();
      },
      builder: (context, state) {
        final t = context.tones;
        Future<void> pick<T>(
          String title,
          List<LedgerOption<T>> options,
          T selected,
          void Function(T) apply,
        ) async {
          final v = await showLedgerOptionsSheet<T>(
            context,
            title: title,
            options: options,
            selected: selected,
          );
          if (v != null) setState(() => apply(v));
        }

        return Scaffold(
          backgroundColor: t.bgPage,
          appBar: PageAppBar(
            title: _isEdit
                ? LocaleKeys.editReminder.tr()
                : LocaleKeys.addReminder.tr(),
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
              children: [
                LedgerNameCard(
                  controller: _titleController,
                  hint: LocaleKeys.reminderTitle.tr(),
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? LocaleKeys.reminderTitleRequired.tr()
                      : null,
                ),
                SizedBox(height: 12.lx),
                LedgerFieldsCard(
                  children: [
                    FormField<DateTime>(
                      initialValue: _triggerAt,
                      validator: (_) => _triggerAt == null
                          ? LocaleKeys.reminderDateTimeRequired.tr()
                          : null,
                      builder: (field) => LedgerFieldRow(
                        icon: LucideIcons.calendarClock,
                        label: LocaleKeys.reminderWhen.tr(),
                        valueWidget: Text(
                          _triggerAt != null
                              ? DateFormat('dd/MM/yyyy HH:mm')
                                  .format(_triggerAt!)
                              : field.errorText ??
                                  LocaleKeys.reminderNoTime.tr(),
                          style: TextStyle(
                            fontSize: 12.5.lx,
                            color: field.hasError
                                ? t.expenseColor
                                : _triggerAt == null
                                    ? t.textMuted
                                    : t.textPrimary,
                          ),
                        ),
                        chevron: true,
                        onTap: () => _pickTrigger(field),
                      ),
                    ),
                    LedgerFieldRow(
                      icon: LucideIcons.repeat,
                      label: LocaleKeys.reminderRepeat.tr(),
                      value: _repeatLabel(_repeat),
                      chevron: true,
                      onTap: () => pick<String>(
                        LocaleKeys.reminderRepeat.tr(),
                        [
                          for (final o in _repeatRules.keys)
                            LedgerOption(o, _repeatLabel(o)),
                        ],
                        _repeat,
                        (v) => _repeat = v,
                      ),
                    ),
                    LedgerFieldRow(
                      icon: LucideIcons.globe,
                      label: LocaleKeys.reminderTimezone.tr(),
                      value: timezones[_timezone] ?? _timezone,
                      chevron: true,
                      onTap: () => pick<String>(
                        LocaleKeys.reminderTimezone.tr(),
                        [
                          for (final e in timezones.entries)
                            LedgerOption(e.key, e.value),
                        ],
                        _timezone,
                        (v) => _timezone = v,
                      ),
                    ),
                    LedgerFieldRow(
                      icon: LucideIcons.tag,
                      label: LocaleKeys.reminderType.tr(),
                      value: reminderTypeLabel(_type),
                      chevron: true,
                      onTap: () => pick<String>(
                        LocaleKeys.reminderType.tr(),
                        [
                          for (final r in ReminderType.all)
                            LedgerOption(r, reminderTypeLabel(r)),
                        ],
                        _type,
                        (v) => _type = v,
                      ),
                    ),
                    LedgerFieldRow(
                      icon: LucideIcons.flag,
                      label: LocaleKeys.reminderPriority.tr(),
                      value: _priorityLabel(_priority),
                      chevron: true,
                      onTap: () => pick<int>(
                        LocaleKeys.reminderPriority.tr(),
                        [
                          for (final p in [0, 1, 2])
                            LedgerOption(p, _priorityLabel(p)),
                        ],
                        _priority,
                        (v) => _priority = v,
                      ),
                    ),
                    LedgerFieldRow(
                      icon: LucideIcons.textAlignStart,
                      label: LocaleKeys.formDescription.tr(),
                      divider: false,
                      valueWidget: LedgerInlineField(
                        controller: _descriptionController,
                        hint: LocaleKeys.typeHere.tr(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18.lx),
                LedgerButton(
                  label: LocaleKeys.saveReminder.tr(),
                  icon: LucideIcons.check,
                  large: true,
                  busy: state.isSaving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
