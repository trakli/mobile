import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/feedback_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/feedback/cubit/feedback_cubit.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/custom_text_field.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/page_app_bar.dart';
import 'package:trakli/presentation/utils/tone_widgets.dart';

/// Lets the user report a problem, ask a question or suggest something, and
/// shows what they have sent before with the status the team gave it.
/// Mirrors the web's pages/feedback.vue.
class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FeedbackCubit>()..loadFeedback(),
      child: const _FeedbackView(),
    );
  }
}

class _FeedbackView extends StatefulWidget {
  const _FeedbackView();

  @override
  State<_FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<_FeedbackView> {
  static const int _subjectMaxLength = 200;
  static const int _messageMinLength = 2;
  static const int _messageMaxLength = 5000;

  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  FeedbackType _type = FeedbackType.general;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<FeedbackCubit>().submitFeedback(
          type: _type,
          subject: _subjectController.text,
          message: _messageController.text,
        );
  }

  /// The type is kept so a run of bug reports does not need it picked again.
  void _onSubmitted() {
    _subjectController.clear();
    _messageController.clear();
    _formKey.currentState?.reset();
    showSnackBar(message: LocaleKeys.feedbackSent.tr(), isSuccess: true);
  }

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return BlocListener<FeedbackCubit, FeedbackState>(
      listenWhen: (previous, current) =>
          previous.submittedCount != current.submittedCount ||
          (previous.failure != current.failure && current.failure.hasError),
      listener: (context, state) {
        if (state.failure.hasError) {
          showSnackBar(message: state.failure);
          return;
        }
        _onSubmitted();
      },
      child: Scaffold(
        backgroundColor: tones.bgPage,
        appBar: PageAppBar(title: LocaleKeys.feedback.tr()),
        body: RefreshIndicator(
          onRefresh: () => context.read<FeedbackCubit>().loadFeedback(),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            children: [
              Text(
                LocaleKeys.feedbackHeadline.tr(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: tones.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                LocaleKeys.feedbackIntro.tr(),
                style: TextStyle(fontSize: 13.sp, color: tones.textSecondary),
              ),
              SizedBox(height: 16.h),
              _buildForm(tones),
              SizedBox(height: 24.h),
              Eyebrow(LocaleKeys.feedbackHistory.tr()),
              SizedBox(height: 8.h),
              const _FeedbackHistory(),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(AppTones tones) {
    return ToneCard(
      padding: EdgeInsets.all(16.r),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _label(tones, LocaleKeys.feedbackType.tr()),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final type in FeedbackType.values)
                  ChoiceChip(
                    label: Text(feedbackTypeLabel(type)),
                    selected: _type == type,
                    onSelected: (_) => setState(() => _type = type),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            _label(tones, LocaleKeys.feedbackSubject.tr()),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: _subjectController,
              hintText: LocaleKeys.feedbackSubjectHint.tr(),
              maxLength: _subjectMaxLength,
              textInputAction: TextInputAction.next,
              filled: true,
            ),
            SizedBox(height: 12.h),
            _label(tones, LocaleKeys.feedbackMessage.tr()),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: _messageController,
              hintText: LocaleKeys.feedbackMessageHint.tr(),
              maxLines: 6,
              maxLength: _messageMaxLength,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              filled: true,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return LocaleKeys.feedbackMessageRequired.tr();
                }
                if (text.length < _messageMinLength) {
                  return LocaleKeys.feedbackMessageTooShort.tr();
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            BlocBuilder<FeedbackCubit, FeedbackState>(
              buildWhen: (previous, current) =>
                  previous.isSubmitting != current.isSubmitting,
              builder: (context, state) {
                return SizedBox(
                  height: 48.h,
                  child: state.isSubmitting
                      ? const Center(child: CircularProgressIndicator())
                      : PrimaryButton(
                          onPress: _submit,
                          buttonText: LocaleKeys.feedbackSend.tr(),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(AppTones tones, String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: tones.textPrimary,
      ),
    );
  }
}

class _FeedbackHistory extends StatelessWidget {
  const _FeedbackHistory();

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;

    return BlocBuilder<FeedbackCubit, FeedbackState>(
      buildWhen: (previous, current) =>
          previous.items != current.items ||
          previous.isLoading != current.isLoading ||
          previous.loadFailure != current.loadFailure,
      builder: (context, state) {
        if (state.isLoading && state.items.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state.loadFailure.hasError && state.items.isEmpty) {
          return ToneCard(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Text(
                  state.loadFailure.customMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: tones.textSecondary),
                ),
                TextButton(
                  onPressed: () => context.read<FeedbackCubit>().loadFeedback(),
                  child: Text(LocaleKeys.retry.tr()),
                ),
              ],
            ),
          );
        }

        if (state.items.isEmpty) {
          return ToneCard(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Text(
                  LocaleKeys.feedbackEmptyTitle.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  LocaleKeys.feedbackEmptyBody.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13.sp, color: tones.textSecondary),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            for (final item in state.items) ...[
              _FeedbackTile(item: item),
              SizedBox(height: 8.h),
            ],
          ],
        );
      },
    );
  }
}

class _FeedbackTile extends StatelessWidget {
  final FeedbackEntity item;

  const _FeedbackTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final tones = context.tones;
    final createdAt = item.createdAt;

    return ToneCard(
      padding: EdgeInsets.all(14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GlassPill(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                child: Text(
                  _statusLabel(item.status),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: tones.textPrimary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                feedbackTypeLabel(item.type),
                style: TextStyle(fontSize: 12.sp, color: tones.textMuted),
              ),
              const Spacer(),
              if (createdAt != null)
                Text(
                  DateFormat.yMMMd(context.locale.toString())
                      .add_jm()
                      .format(createdAt),
                  style: TextStyle(fontSize: 11.sp, color: tones.textMuted),
                ),
            ],
          ),
          if (item.subject != null && item.subject!.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              item.subject!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: tones.textPrimary,
              ),
            ),
          ],
          SizedBox(height: 6.h),
          Text(
            item.message,
            style: TextStyle(fontSize: 13.sp, color: tones.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Statuses are triage labels set by the team (e.g. `in_progress`); show
  /// them as words rather than keys.
  String _statusLabel(String status) {
    final words = status.replaceAll('_', ' ').trim();
    if (words.isEmpty) return words;
    return words[0].toUpperCase() + words.substring(1);
  }
}

String feedbackTypeLabel(FeedbackType type) => switch (type) {
      FeedbackType.general => LocaleKeys.feedbackTypeGeneral.tr(),
      FeedbackType.bug => LocaleKeys.feedbackTypeBug.tr(),
      FeedbackType.feature => LocaleKeys.feedbackTypeFeature.tr(),
      FeedbackType.question => LocaleKeys.feedbackTypeQuestion.tr(),
    };
