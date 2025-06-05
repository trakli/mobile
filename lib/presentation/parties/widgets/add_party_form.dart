import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/helpers.dart';

class AddPartyForm extends StatefulWidget {
  final PartyEntity? party;
  final bool showClose;

  const AddPartyForm({
    super.key,
    this.party,
    this.showClose = false,
  });

  @override
  State<AddPartyForm> createState() => _AddPartyFormState();
}

class _AddPartyFormState extends State<AddPartyForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.party != null) {
      _nameController.text = widget.party!.name;
      _descriptionController.text = widget.party!.description ?? '';
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

    if (widget.party != null) {
      context.read<PartyCubit>().updateParty(
            widget.party!.clientId,
            name: name,
            description: description.isEmpty ? null : description,
          );
    } else {
      context.read<PartyCubit>().addParty(
            name,
            description: description.isEmpty ? null : description,
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
              content: Text(state.failure.customMessage),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (!state.isSaving && !state.failure.hasError) {
          AppNavigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Stack(
          children: [
            Container(
              padding: widget.showClose ? EdgeInsets.only(top: 18.h) : null,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.partyEnterPartyName.tr(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return LocaleKeys.partyNameRequired.tr();
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: LocaleKeys.typeHere.tr(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 54.h,
                      width: double.infinity,
                      child: Builder(
                        builder: (context) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: _onSubmit,
                            child: Row(
                              spacing: 8.w,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.party != null
                                      ? LocaleKeys.partyUpdate.tr()
                                      : LocaleKeys.partyCreateParty.tr(),
                                ),
                                SvgPicture.asset(
                                  Assets.images.add,
                                  width: 24,
                                  height: 24,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.showClose)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    AppNavigator.pop(context);
                  },
                  icon: const Icon(Icons.close),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
