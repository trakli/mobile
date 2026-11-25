import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/space/space_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/spaces/cubit/space_cubit.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class SpaceInvitationScreen extends StatefulWidget {
  final String token;

  const SpaceInvitationScreen({super.key, required this.token});

  @override
  State<SpaceInvitationScreen> createState() => _SpaceInvitationScreenState();
}

class _SpaceInvitationScreenState extends State<SpaceInvitationScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<SpaceCubit>();
    if (cubit.state.invitation == null && !cubit.state.isLoadingInvitation) {
      cubit.previewInvitation(widget.token);
    }
  }

  Future<void> _accept() async {
    final cubit = context.read<SpaceCubit>();
    final navigator = Navigator.of(context);
    await cubit.acceptInvitation(widget.token);
    if (cubit.state.acceptedSlug != null && navigator.mounted) {
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Scaffold(
      backgroundColor: t.bgPage,
      body: SafeArea(
        child: BlocBuilder<SpaceCubit, SpaceState>(
          builder: (context, state) {
            final invitation = state.invitation;
            final hasFailure = state.failure != const Failure.none();
            if (state.isLoadingInvitation) {
              return Center(
                child: CircularProgressIndicator(color: t.brandText),
              );
            }
            final closed = _closedMessage(invitation, state);
            return Padding(
              padding: EdgeInsets.fromLTRB(14.lx, 10.lx, 14.lx, 14.lx),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: invitation == null
                            ? _Message(
                                text: hasFailure
                                    ? LocaleKeys.spaceInvitationBroken.tr()
                                    : '',
                              )
                            : _Body(invitation: invitation),
                      ),
                    ),
                  ),
                  if (closed != null) ...[
                    _Message(text: closed),
                    SizedBox(height: 14.lx),
                  ] else if (invitation != null && hasFailure) ...[
                    Text(
                      state.failure.customMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.lx, color: t.expenseColor),
                    ),
                    SizedBox(height: 10.lx),
                  ],
                  if (invitation != null && closed == null) ...[
                    LedgerButton(
                      label: LocaleKeys.spaceAcceptAndOpen.tr(),
                      icon: LucideIcons.check,
                      large: true,
                      busy: state.isRespondingInvitation,
                      onPressed: _accept,
                    ),
                    SizedBox(height: 10.lx),
                  ],
                  LedgerButton(
                    label: LocaleKeys.spaceNotNow.tr(),
                    style: LedgerButtonStyle.outline,
                    large: true,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  if (invitation != null && closed == null) ...[
                    SizedBox(height: 6.lx),
                    TextButton(
                      onPressed: state.isRespondingInvitation
                          ? null
                          : () => context
                              .read<SpaceCubit>()
                              .declineInvitation(widget.token),
                      child: Text(
                        LocaleKeys.spaceDecline.tr(),
                        style: TextStyle(
                          fontSize: 12.5.lx,
                          color: t.textMuted,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String? _closedMessage(SpaceInvitationEntity? invitation, SpaceState state) {
    if (state.invitationDeclined) return LocaleKeys.spaceInvitationDeclined.tr();
    return switch (invitation?.status) {
      SpaceInvitationStatus.accepted =>
        LocaleKeys.spaceInvitationAlreadyAccepted.tr(),
      SpaceInvitationStatus.declined =>
        LocaleKeys.spaceInvitationWasDeclined.tr(),
      SpaceInvitationStatus.expired => LocaleKeys.spaceInvitationExpired.tr(),
      _ => null,
    };
  }
}

class _Message extends StatelessWidget {
  final String text;
  const _Message({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 13.lx,
        height: 1.45,
        color: context.tones.textSecondary,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final SpaceInvitationEntity invitation;
  const _Body({required this.invitation});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    final inviter = invitation.invitedBy?.trim();
    final title = inviter == null || inviter.isEmpty
        ? LocaleKeys.spaceYouAreInvitedTo
            .tr(namedArgs: {'name': invitation.workspaceName})
        : LocaleKeys.spaceInvitedYouTo.tr(namedArgs: {
            'inviter': inviter,
            'name': invitation.workspaceName,
          });
    final faces = [
      invitation.workspaceName,
      if (inviter != null && inviter.isNotEmpty) inviter,
    ];
    final points = [
      (LucideIcons.eye, LocaleKeys.spaceInvitePointSee.tr()),
      (
        LucideIcons.pencil,
        invitation.role == 'admin'
            ? LocaleKeys.spaceInvitePointAdmin.tr()
            : LocaleKeys.spaceInvitePointMember.tr(),
      ),
      (LucideIcons.lock, LocaleKeys.spaceInvitePointPrivate.tr()),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < faces.length; i++)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: t.bgSurface, width: 2),
                  borderRadius: BorderRadius.circular(AppRadii.sm + 2),
                ),
                child: LedgerInitials(faces[i], size: 40),
              ),
          ],
        ),
        SizedBox(height: 12.lx),
        Text(
          LocaleKeys.spaceSharedSpace.tr().toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11.lx,
            letterSpacing: 0.09 * 11.lx,
            color: t.textMuted,
          ),
        ),
        SizedBox(height: 14.lx),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.lx,
            fontWeight: FontWeight.w700,
            height: 1.25,
            letterSpacing: -0.02 * 20.lx,
            color: t.textPrimary,
          ),
        ),
        SizedBox(height: 16.lx),
        for (var i = 0; i < points.length; i++)
          _Point(
            icon: points[i].$1,
            text: points[i].$2,
            divider: i < points.length - 1,
          ),
      ],
    );
  }
}

class _Point extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool divider;

  const _Point({required this.icon, required this.text, required this.divider});

  @override
  Widget build(BuildContext context) {
    final t = context.tones;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9.lx),
      decoration: BoxDecoration(
        border: divider
            ? Border(bottom: BorderSide(color: t.borderLight))
            : null,
      ),
      child: Row(
        children: [
          LedgerCoin(icon: icon, size: 30),
          SizedBox(width: 11.lx),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.lx, height: 1.4, color: t.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
