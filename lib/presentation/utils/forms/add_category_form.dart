import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/domain/entities/media_entity.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/utils/bottom_sheets/select_icon_bottom_sheet.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/ledger/ledger_form.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';

class AddCategoryForm extends StatefulWidget {
  final Color accentColor;
  final CategoryEntity? category;
  final TransactionType type;
  final Function(
      {required String name,
      required String description,
      required TransactionType type,
      IconData? icon,
      MediaEntity? mediaEntity}) onSubmit;

  const AddCategoryForm({
    super.key,
    this.accentColor = const Color(0xFFEB5757),
    this.category,
    required this.onSubmit,
    required this.type,
  });

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late IconData? selectedIcon;
  MediaEntity? mediaEntity;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name);
    _descriptionController =
        TextEditingController(text: widget.category?.description);
    selectedIcon = Icons.add;
    mediaEntity = widget.category?.icon;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    hideKeyBoard();
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        name: _nameController.text,
        description: _descriptionController.text,
        type: widget.type,
        mediaEntity: mediaEntity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final income = widget.type == TransactionType.income;
    return Form(
      key: _formKey,
      child: ListView(
        padding: EdgeInsets.fromLTRB(14.lx, 6.lx, 14.lx, 40.lx),
        children: [
          LedgerNameCard(
            controller: _nameController,
            hint: LocaleKeys.categoryName.tr(),
            media: mediaEntity,
            accent: widget.accentColor,
            onPickIcon: () => showCustomBottomSheet(
              context,
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
                icon: income
                    ? LucideIcons.arrowDownLeft
                    : LucideIcons.arrowUpRight,
                label: LocaleKeys.type.tr(),
                valueWidget: Align(
                  alignment: Alignment.centerLeft,
                  child: LedgerChip(
                    income
                        ? LocaleKeys.transactionIncome.tr()
                        : LocaleKeys.transactionExpense.tr(),
                    tone: income ? LedgerChipTone.good : LedgerChipTone.bad,
                  ),
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
            label: widget.category != null
                ? LocaleKeys.updateCategory.tr()
                : LocaleKeys.createCategory.tr(),
            icon:
                widget.category != null ? LucideIcons.check : LucideIcons.plus,
            large: true,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
