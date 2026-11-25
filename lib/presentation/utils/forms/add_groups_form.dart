import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_form.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class AddGroupsForm extends StatefulWidget {
  final GroupEntity? group;

  const AddGroupsForm({
    super.key,
    this.group,
  });

  @override
  State<AddGroupsForm> createState() => _AddGroupsFormState();
}

class _AddGroupsFormState extends State<AddGroupsForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late MediaEntity? mediaEntity;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.group?.name);
    _descriptionController =
        TextEditingController(text: widget.group?.description);
    mediaEntity = widget.group?.icon;
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCubit, GroupState>(
      listenWhen: (previous, current) => previous.isSaving != current.isSaving,
      listener: (context, state) {
        if (state.failure.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.maybeMap(
                orElse: () => state.failure.customMessage,
                duplicate: (_) => LocaleKeys.groupNameAlreadyExists.tr(),
              )),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (!state.isSaving && !state.failure.hasError) {
          AppNavigator.pop(context);
        }
      },
      builder: (context, state) {
        return Form(
          child: Builder(
            builder: (context) => ListView(
              padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
              children: [
                LedgerNameCard(
                  controller: _nameController,
                  hint: LocaleKeys.groupEnterGroupName.tr(),
                  media: mediaEntity,
                  onPickIcon: () => showCustomBottomSheet(
                    context,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    widget: SelectIconBottomSheet(
                      onSelect: (mediaType, image) => setState(() {
                        mediaEntity =
                            MediaEntity(content: image, mediaType: mediaType);
                      }),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? LocaleKeys.nameIsRequired.tr()
                      : null,
                ),
                SizedBox(height: 12.lx),
                LedgerFieldsCard(
                  children: [
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
                  label: widget.group == null
                      ? LocaleKeys.groupCreateGroup.tr()
                      : LocaleKeys.groupUpdate.tr(),
                  icon: widget.group == null
                      ? LucideIcons.plus
                      : LucideIcons.check,
                  large: true,
                  busy: state.isSaving,
                  onPressed: () => _submit(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    hideKeyBoard();
    if (!Form.of(context).validate()) return;
    final description = _descriptionController.text.isEmpty
        ? null
        : _descriptionController.text;
    final media = mediaEntity?.content?.isEmpty == true ? null : mediaEntity;
    final cubit = context.read<GroupCubit>();
    if (widget.group == null) {
      cubit.addGroup(_nameController.text,
          description: description, media: media);
    } else {
      cubit.updateGroup(widget.group!.clientId,
          name: _nameController.text, description: description, media: media);
    }
  }
}
