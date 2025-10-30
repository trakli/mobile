import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trakli/core/constants/key_constants.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/presentation/utils/buttons.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/popovers/wallet_type_popover.dart';

class WalletSetupWidget extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const WalletSetupWidget({
    super.key,
    required this.onNext,
    required this.onPrev,
  });

  @override
  State<WalletSetupWidget> createState() => _WalletSetupWidgetState();
}

class _WalletSetupWidgetState extends State<WalletSetupWidget> {
  WalletOption? _selectedWalletOption = WalletOption.useDefault;
  final TextEditingController _optionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final GlobalKey gloKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  Currency? currency;
  late Currency xafCurrency;
  Currency? defaultCurrency;

  void _loadCurrencies() {
    setState(() {
      const countryCode = KeyConstants.defaultCurrencyCode;
      final allCurrencies = CurrencyService().getAll();
      // Make XAF (Cameroon) the default
      setState(() {
        xafCurrency = allCurrencies.firstWhere((c) => c.code == countryCode);
      });
      _currencyController.text = "${xafCurrency.code} - ${xafCurrency.name}";
    });
  }

  @override
  void initState() {
    _loadCurrencies();
    _optionController.text = _selectedWalletOption?.customName.tr() ?? "";
    super.initState();
  }

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingCubit, OnboardingState>(
      listener: (BuildContext context, OnboardingState state) {
        state.when(
          initial: () {},
          loading: () {
            showLoader();
          },
          success: (user) {
            hideLoader();
          },
          error: (failure) {
            hideLoader();
            showSnackBar(
              message: failure.customMessage,
              borderRadius: 8.r,
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 0.h),
            CircleAvatar(
              radius: 30.sp,
              backgroundColor: appPrimaryColor.withAlpha(30),
              child: Icon(
                Icons.wallet,
                size: 28.sp,
                color: appPrimaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              LocaleKeys.setupWalletTitle.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              LocaleKeys.setupWalletDesc.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleKeys.walletSetup.tr(),
                    style: TextStyle(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Builder(builder: (context) {
                    return TextFormField(
                      controller: _optionController,
                      readOnly: true,
                      key: gloKey,
                      onTap: () {
                        showCustomPopOver(
                          context,
                          maxWidth: 0.8.sw,
                          widget: WalletTypePopover(
                            onSelect: (type) {
                              setState(() {
                                _selectedWalletOption = type;
                              });
                              _optionController.text =
                                  _selectedWalletOption?.customName.tr() ?? "";
                            },
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: SvgPicture.asset(
                            Assets.images.arrowDown,
                          ),
                        ),
                      ),
                    );
                  }),
                  if (_selectedWalletOption != WalletOption.useDefault) ...[
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16.w,
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: LocaleKeys.enterName.tr(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return LocaleKeys.nameIsRequired.tr();
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        if (_selectedWalletOption == WalletOption.createNew)
                          GestureDetector(
                            onTap: () async {
                              showCurrencyPicker(
                                context: context,
                                theme: CurrencyPickerThemeData(
                                    bottomSheetHeight: 0.7.sh,
                                    backgroundColor: Colors.white,
                                    flagSize: 24.sp,
                                    subtitleTextStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                onSelect: (Currency currencyValue) {
                                  setState(() {
                                    currency = currencyValue;
                                  });
                                },
                              );
                            },
                            child: Container(
                              width: 60.w,
                              constraints: BoxConstraints(
                                maxHeight: 50.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDEE1E0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  currency?.code ?? 'XAF',
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ],
                  SizedBox(height: 16.h),
                  Text(
                    LocaleKeys.defaultCurrency.tr(),
                    style: TextStyle(
                      fontSize: 16.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextFormField(
                    controller: _currencyController,
                    readOnly: true,
                    onTap: () {
                      showCurrencyPicker(
                        context: context,
                        theme: CurrencyPickerThemeData(
                            bottomSheetHeight: 0.7.sh,
                            backgroundColor: Colors.white,
                            flagSize: 24.sp,
                            subtitleTextStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).primaryColor,
                            )),
                        onSelect: (Currency currency) {
                          setState(() {
                            defaultCurrency = currency;
                            context
                                .read<OnboardingCubit>()
                                .selectCurrency(currency);
                          });
                          _currencyController.text =
                              "${currency.code} - ${currency.name}";
                        },
                      );
                    },
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(10.sp),
                        child: SvgPicture.asset(
                          Assets.images.arrowDown,
                        ),
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            child: flagWidget(
                          defaultCurrency ?? xafCurrency,
                          fontSize: 20.sp,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onPrev,
                  child: Text(LocaleKeys.prev.tr()),
                ),
                PrimaryButton(
                  onPress: () {
                    if (defaultCurrency == null) {
                      context
                          .read<OnboardingCubit>()
                          .selectCurrency(xafCurrency);
                    }
                    if (_selectedWalletOption == WalletOption.useDefault ||
                        (_formKey.currentState?.validate() ?? false)) {
                      widget.onNext();
                    }
                  },
                  buttonText: LocaleKeys.next.tr(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
