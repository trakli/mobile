import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/parties/widgets/party_list_tile.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_form.dart';
import 'package:trakli/presentation/utils/ledger/ledger_settings.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class AddPartyForm extends StatefulWidget {
  final PartyEntity? party;

  const AddPartyForm({
    super.key,
    this.party,
  });

  @override
  State<AddPartyForm> createState() => _AddPartyFormState();
}

class _AddPartyFormState extends State<AddPartyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  MediaEntity? mediaEntity;
  PartyType? _selectedType;

  @override
  void initState() {
    super.initState();
    if (widget.party != null) {
      _nameController.text = widget.party!.name;
      _descriptionController.text = widget.party!.description ?? '';
      mediaEntity = widget.party?.icon;
      _selectedType = widget.party?.type;
    } else {
      _selectedType = PartyType.individual;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    hideKeyBoard();
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();
    final type = _selectedType;
    if (type == null) return;

    if (widget.party != null) {
      context.read<PartyCubit>().updateParty(
            widget.party!.clientId,
            name: name,
            description: description.isEmpty ? null : description,
            media: mediaEntity,
            type: type,
          );
    } else {
      context.read<PartyCubit>().addParty(
            name,
            description: description.isEmpty ? null : description,
            media: mediaEntity,
            type: type,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PartyCubit, PartyState>(
      listenWhen: (previous, current) => previous.isSaving != current.isSaving,
      listener: (context, state) {
        if (state.failure.hasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.maybeMap(
                orElse: () => state.failure.customMessage,
                duplicate: (_) => LocaleKeys.partyNameAlreadyExists.tr(),
              )),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (!state.isSaving && !state.failure.hasError) {
          AppNavigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
          children: [
            LedgerNameCard(
              controller: _nameController,
              hint: LocaleKeys.partyEnterPartyName.tr(),
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
              validator: (value) => value == null || value.trim().isEmpty
                  ? LocaleKeys.partyNameRequired.tr()
                  : null,
            ),
            SizedBox(height: 12.lx),
            LedgerFieldsCard(
              children: [
                LedgerFieldRow(
                  icon: PartyListTile.iconForType(_selectedType),
                  label: LocaleKeys.type.tr(),
                  value: _selectedType?.customName ??
                      LocaleKeys.selectPartyType.tr(),
                  placeholder: _selectedType == null,
                  chevron: true,
                  onTap: _pickType,
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
            BlocBuilder<PartyCubit, PartyState>(
              builder: (context, state) => LedgerButton(
                label: widget.party != null
                    ? LocaleKeys.partyUpdate.tr()
                    : LocaleKeys.partyCreateParty.tr(),
                icon:
                    widget.party != null ? LucideIcons.check : LucideIcons.plus,
                large: true,
                busy: state.isSaving,
                onPressed: _onSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickType() async {
    final picked = await showLedgerOptionsSheet<PartyType>(
      context,
      title: LocaleKeys.type.tr(),
      selected: _selectedType,
      options: [
        for (final type in PartyType.values)
          LedgerOption(
            type,
            type.customName,
            leading: Icon(PartyListTile.iconForType(type), size: 17.lx),
          ),
      ],
    );
    if (picked != null) setState(() => _selectedType = picked);
  }
}
