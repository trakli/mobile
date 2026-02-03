import 'package:collection/collection.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:currency_picker/currency_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/core/extensions/string_extension.dart';
import 'package:trakli/domain/entities/category_entity.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/category/add_category_screen.dart';
import 'package:trakli/presentation/category/cubit/category_cubit.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';
import 'package:trakli/presentation/currency/cubit/currency_cubit.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/transactions/view_attachment_screen.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/custom_auto_complete_search.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/domain/entities/media_file_entity.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/wallets/add_wallet_screen.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';
import 'package:trakli/providers/chart_data_provider.dart';

class AddTransactionFormCompactLayout extends StatefulWidget {
  final TransactionType transactionType;
  final Color accentColor;
  final TransactionCompleteEntity? transactionCompleteEntity;

  const AddTransactionFormCompactLayout({
    super.key,
    this.transactionType = TransactionType.income,
    this.accentColor = const Color(0xFFEB5757),
    this.transactionCompleteEntity,
  });

  @override
  State<AddTransactionFormCompactLayout> createState() =>
      _AddTransactionFormCompactLayoutState();
}

class _AddTransactionFormCompactLayoutState
    extends State<AddTransactionFormCompactLayout> {
  int? selectedIndex;
  DateFormat dateFormat = DateFormat('dd-MM-yyy');
  DateFormat timeFormat = DateFormat('h:mm:a');
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoryEntity? _selectedCategory;
  WalletEntity? _selectedWallet;
  PartyEntity? _selectedParty;
  List<String> attachedFilePaths = [];
  List<MediaFileEntity> existingMedia = [];
  final Map<int, String> _loadedMediaPaths = {};
  final Set<int> _failedMediaIds = {};
  final Map<String, Uint8List> _pdfThumbnailBytes = {};
  final _formKey = GlobalKey<FormState>();

  static bool _isPdfPath(String path) => path.toLowerCase().endsWith('.pdf');

  Future<void> _loadPdfThumbnails() async {
    const thumbSize = 144;
    final toLoad = <String, String?>{};
    for (final m in existingMedia) {
      if (!_isPdfPath(m.path)) continue;
      if (_pdfThumbnailBytes.containsKey(m.path)) continue;
      // Server media: use cached path when loaded; local-only (id == null): use m.path directly.
      final filePath = m.id != null ? _loadedMediaPaths[m.id] : m.path;
      if (filePath != null) toLoad[m.path] = filePath;
    }
    for (final path in attachedFilePaths) {
      if (!_isPdfPath(path)) continue;
      if (_pdfThumbnailBytes.containsKey(path)) continue;
      if (File(path).existsSync()) toLoad[path] = null;
    }
    for (final e in toLoad.entries) {
      final thumb = await renderPdfFirstPageThumbnail(
        filePath: e.value ?? e.key,
        bytes: null,
        size: thumbSize,
      );
      if (!mounted) return;
      if (thumb != null) {
        setState(() => _pdfThumbnailBytes[e.key] = thumb);
      }
    }
  }

  Future<void> _loadPdfThumbnailForPath(String path) async {
    if (!_isPdfPath(path) || _pdfThumbnailBytes.containsKey(path)) return;
    final thumb = await renderPdfFirstPageThumbnail(filePath: path, size: 144);
    if (!mounted) return;
    if (thumb != null) {
      setState(() => _pdfThumbnailBytes[path] = thumb);
    }
  }

  Currency? currentCurrency;
  final pieData = StatisticsProvider().getPieData;

  setCurrencyFromWallet(WalletEntity? wallet) {
    setState(() {
      currentCurrency = wallet?.currency ?? currentCurrency;
    });
  }

  setCurrency(Currency currency) {
    setState(() {
      _selectedWallet = null;
      currentCurrency = currency;
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.transactionCompleteEntity != null) {
      final wallet = widget.transactionCompleteEntity?.wallet;
      setCurrencyFromWallet(wallet);

      amountController.text =
          widget.transactionCompleteEntity!.transaction.amount.toString();

      descriptionController.text =
          widget.transactionCompleteEntity!.transaction.description;
      date = widget.transactionCompleteEntity!.transaction.datetime.toLocal();
      dateController.text = dateFormat.format(
          widget.transactionCompleteEntity!.transaction.datetime.toLocal());
      timeController.text = timeFormat.format(
          widget.transactionCompleteEntity!.transaction.datetime.toLocal());
      if (widget.transactionCompleteEntity?.categories != null &&
          widget.transactionCompleteEntity!.categories.isNotEmpty) {
        _selectedCategory = widget.transactionCompleteEntity!.categories.first;
      }

      if (widget.transactionCompleteEntity?.wallet != null) {
        _selectedWallet = widget.transactionCompleteEntity!.wallet;
      }

      if (widget.transactionCompleteEntity?.party != null) {
        _selectedParty = widget.transactionCompleteEntity!.party;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final list = widget.transactionCompleteEntity!.files;
        setState(() {
          existingMedia = list;
          _loadedMediaPaths
              .removeWhere((id, _) => !list.any((m) => m.id == id));
          _failedMediaIds.removeWhere((id) => !list.any((m) => m.id == id));
          _loadMediaThumbnails(list);
        });
      });
    } else {
      date = DateTime.now();
      dateController.text = dateFormat.format(date);
      timeController.text = timeFormat.format(date);

      final currencyState = context.read<CurrencyCubit>().state;
      currentCurrency = currencyState.currency ?? currentCurrency;

      // Always use default wallet from config
      final configState = context.read<ConfigCubit>().state;
      final defaultWalletConfig =
          configState.getConfigByKey(ConfigConstants.defaultWallet);
      final defaultWalletId = defaultWalletConfig?.value as String?;

      if (defaultWalletId != null) {
        final walletState = context.read<WalletCubit>().state;
        final defaultWallet = walletState.wallets.firstWhereOrNull(
          (wallet) => wallet.clientId == defaultWalletId,
        );

        if (defaultWallet != null) {
          _selectedWallet = defaultWallet;
          setCurrencyFromWallet(defaultWallet);
        }
      }
    }
  }

  Future<void> _loadMediaThumbnails(List<MediaFileEntity> mediaList) async {
    final withIds = mediaList.where((m) => m.id != null).toList();
    if (withIds.isNotEmpty) {
      final cubit = context.read<TransactionCubit>();
      final futures = withIds.map((media) async {
        final result = await cubit.getFileContent(media.id!);
        return (media.id!, result);
      });
      final results = await Future.wait(futures);
      if (!mounted) return;
      setState(() {
        for (final (id, result) in results) {
          result.fold(
            (_) => _failedMediaIds.add(id),
            (filePath) {
              _loadedMediaPaths[id] = filePath;
              _failedMediaIds.remove(id);
            },
          );
        }
      });
    }
    // Always load PDF thumbnails so local-only files (no id, path like app_flutter/media/xxx.pdf) get thumbnails too.
    _loadPdfThumbnails();
  }

  static bool _isImageExt(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ext == 'png' ||
        ext == 'jpg' ||
        ext == 'jpeg' ||
        ext == 'gif' ||
        ext == 'webp';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      listenWhen: (previous, current) {
        // Listen when saving completes (isSaving goes from true to false)
        return previous.isSaving && !current.isSaving;
      },
      listener: (context, state) {
        // Only navigate if save was successful (no error)
        if (!state.failure.hasError && mounted) {
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.exampleAmount.tr(),
                          labelText: LocaleKeys.transactionAmount.tr(),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: widget.accentColor,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.amountIsRequired.tr();
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return LocaleKeys.mustBeNumber.tr();
                          }
                          if (number == 0) {
                            return LocaleKeys.amountMustNotBeZero.tr();
                          }
                          return null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCurrencyPicker(
                          context: context,
                          theme: CurrencyPickerThemeData(
                            bottomSheetHeight: 0.7.sh,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            flagSize: 24.sp,
                            subtitleTextStyle: TextStyle(
                              fontSize: 12.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onSelect: (Currency currencyValue) {
                            setCurrency(currencyValue);
                          },
                        );
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(currentCurrency?.code ?? "XAF"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BlocBuilder<WalletCubit, WalletState>(
                        builder: (context, state) {
                          return CustomAutoCompleteSearch<WalletEntity>(
                            key: ValueKey(
                                'wallet_${currentCurrency?.code ?? 'none'}'),
                            label: LocaleKeys.wallet.tr(),
                            accentColor: widget.accentColor,
                            initialValue: _selectedWallet,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              Iterable<WalletEntity> filteredWallets =
                                  state.wallets;
                              if (currentCurrency != null) {
                                filteredWallets =
                                    filteredWallets.where((wallet) {
                                  return wallet.currencyCode ==
                                      currentCurrency!.code;
                                });
                              }

                              if (textEditingValue.text.isNotEmpty) {
                                filteredWallets =
                                    filteredWallets.where((wallet) {
                                  return wallet.name.toLowerCase().contains(
                                      textEditingValue.text.toLowerCase());
                                });
                              }
                              return filteredWallets;
                            },
                            displayStringForOption: (WalletEntity option) {
                              return option.name.capitalizeFirst();
                            },
                            onSelected: (value) {
                              setState(() {
                                _selectedWallet = value;
                                setCurrencyFromWallet(value);
                              });
                            },
                            validator: (value) {
                              if (_selectedWallet == null) {
                                return LocaleKeys.walletIsRequired.tr();
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        AppNavigator.push(context, const AddWalletScreen());
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.images.add,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onSurface,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: dateController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.date.tr(),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            Assets.images.calendar,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: widget.accentColor,
                          ),
                        ),
                      ),
                      onTap: () async {
                        final selectDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().subtract(
                            const Duration(days: 1000),
                          ),
                          lastDate: DateTime.now().add(
                            const Duration(days: 1000),
                          ),
                        );
                        if (selectDate != null) {
                          setState(() {
                            date = selectDate;
                            dateController.text = dateFormat.format(date);
                          });
                        }
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: timeController,
                      decoration: InputDecoration(
                        labelText: LocaleKeys.time.tr(),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(12),
                          child: SvgPicture.asset(
                            Assets.images.clock,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: widget.accentColor,
                          ),
                        ),
                      ),
                      onTap: () async {
                        final selectTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (selectTime != null) {
                          setState(() {
                            time = selectTime;
                            date = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              selectTime.hour,
                              selectTime.minute,
                            );
                            timeController.text = timeFormat.format(date);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BlocBuilder<PartyCubit, PartyState>(
                        builder: (context, state) {
                          return CustomAutoCompleteSearch<PartyEntity>(
                            label: widget.transactionType ==
                                    TransactionType.expense
                                ? '${LocaleKeys.transactionSentTo.tr()} (${LocaleKeys.party.tr()})'
                                : '${LocaleKeys.transactionReceivedFrom.tr()} (${LocaleKeys.party.tr()})',
                            accentColor: widget.accentColor,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return state.parties;
                              }
                              return state.parties.where((category) {
                                return category.name.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            },
                            displayStringForOption: (PartyEntity option) {
                              return option.name.capitalizeFirst();
                            },
                            onSelected: (value) {
                              setState(() {
                                debugPrint(value.name);
                                _selectedParty = value;
                              });
                            },
                            // selectedItem: _selectedCategory,
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        AppNavigator.push(context, const AddPartyScreen());
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.images.add,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onSurface,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              IntrinsicHeight(
                child: Row(
                  spacing: 16.w,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BlocBuilder<CategoryCubit, CategoryState>(
                        builder: (context, state) {
                          //Category by transaction type
                          final searchCategories = state.categories.where(
                              (element) =>
                                  element.type == widget.transactionType);

                          return CustomAutoCompleteSearch<CategoryEntity>(
                            label: LocaleKeys.transactionCategory.tr(),
                            accentColor: widget.accentColor,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return searchCategories;
                              }
                              return searchCategories.where((category) {
                                return category.name.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            },
                            displayStringForOption: (CategoryEntity option) {
                              return option.name.capitalizeFirst();
                            },
                            onSelected: (value) {
                              setState(() {
                                debugPrint(value.name);
                                _selectedCategory = value;
                              });
                            },
                            // selectedItem: _selectedCategory,
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        AppNavigator.push(
                          context,
                          AddCategoryScreen(
                            accentColor: widget.accentColor,
                            type: widget.transactionType,
                          ),
                        );
                      },
                      child: Container(
                        width: 60.w,
                        constraints: BoxConstraints(
                          maxHeight: 50.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.images.add,
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.onSurface,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: LocaleKeys.transactionDescription.tr(),
                  hintText: LocaleKeys.transactionTypeHere.tr(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.accentColor,
                    ),
                  ),
                ),
                onTap: () async {},
              ),
              SizedBox(height: 16.h),
              Row(
                spacing: 8.w,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final file = await pickImageApp(
                          sourcePick: ImageSource.camera,
                        );
                        if (file != null && mounted) {
                          try {
                            final path = file.path;
                            setState(() => attachedFilePaths = [
                                  ...attachedFilePaths,
                                  path
                                ]);
                            if (_isPdfPath(path)) {
                              _loadPdfThumbnailForPath(path);
                            }
                          } catch (e) {
                            if (mounted) {
                              showSnackBar(
                                message: LocaleKeys.unknownErrorDesc.tr(),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Row(
                          spacing: 4.w,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.images.camera,
                              colorFilter: ColorFilter.mode(
                                widget.accentColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                LocaleKeys.snapPicture.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final file = await pickImageApp(
                          sourcePick: ImageSource.gallery,
                        );
                        if (file != null && mounted) {
                          try {
                            final path = file.path;
                            setState(() => attachedFilePaths = [
                                  ...attachedFilePaths,
                                  path
                                ]);
                            if (_isPdfPath(path)) {
                              _loadPdfThumbnailForPath(path);
                            }
                          } catch (e) {
                            if (mounted) {
                              showSnackBar(
                                message: LocaleKeys.unknownErrorDesc.tr(),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Row(
                          spacing: 4.w,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.images.galleryAdd,
                              colorFilter: ColorFilter.mode(
                                widget.accentColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                LocaleKeys.gallery.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final file = await pickFile();
                        if (file != null && mounted) {
                          try {
                            final path = file.path;
                            setState(() => attachedFilePaths = [
                                  ...attachedFilePaths,
                                  path
                                ]);
                            if (_isPdfPath(path)) {
                              _loadPdfThumbnailForPath(path);
                            }
                          } catch (e) {
                            if (mounted) {
                              showSnackBar(
                                message: LocaleKeys.unknownErrorDesc.tr(),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Row(
                          spacing: 4.w,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.images.galleryAdd,
                              colorFilter: ColorFilter.mode(
                                widget.accentColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                LocaleKeys.gallery.tr(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        final file = await pickFile();
                        if (file != null && mounted) {
                          try {
                            final path = file.path;
                            setState(() => attachedFilePaths = [
                                  ...attachedFilePaths,
                                  path
                                ]);
                            if (_isPdfPath(path)) {
                              _loadPdfThumbnailForPath(path);
                            }
                          } catch (e) {
                            if (mounted) {
                              showSnackBar(
                                message: LocaleKeys.unknownErrorDesc.tr(),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Row(
                          spacing: 4.w,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.images.documentUpload,
                              colorFilter: ColorFilter.mode(
                                widget.accentColor,
                                BlendMode.srcIn,
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.uploadAttachment.tr(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(LocaleKeys.transactionFileType.tr(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontSize: 8.sp,
                                          )),
                                  Text(
                                    LocaleKeys.transactionFileType.tr(),
                                    style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            fontSize: 8.sp,
                                          ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (attachedFilePaths.isNotEmpty || existingMedia.isNotEmpty) ...[
                SizedBox(height: 12.h),
                SizedBox(
                  height: 72.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: existingMedia.length + attachedFilePaths.length,
                    separatorBuilder: (_, __) => SizedBox(width: 8.w),
                    itemBuilder: (context, index) {
                      final isExisting = index < existingMedia.length;
                      final path = isExisting
                          ? existingMedia[index].path
                          : attachedFilePaths[index - existingMedia.length];
                      final mediaId =
                          isExisting ? existingMedia[index].id : null;
                      final file = File(path);
                      final ext = path.split('.').last.toLowerCase();
                      final isImage = ext == 'png' ||
                          ext == 'jpg' ||
                          ext == 'jpeg' ||
                          ext == 'gif' ||
                          ext == 'webp';
                      final name = path.split(Platform.pathSeparator).last;

                      // Server media (has id): show loaded path, loader, or file icon
                      final hasServerId = mediaId != null;
                      final loadedPath =
                          hasServerId ? _loadedMediaPaths[mediaId] : null;
                      final loadFailed =
                          hasServerId && _failedMediaIds.contains(mediaId);
                      final isLoading =
                          hasServerId && loadedPath == null && !loadFailed;
                      // Image types and PDF (first-page thumbnail) get a preview; others show file icon.
                      final showPreviewFromFile =
                          !hasServerId && isImage && file.existsSync();
                      final showPreviewFromPath = hasServerId &&
                          loadedPath != null &&
                          _isImageExt(path);
                      final showImagePreview =
                          showPreviewFromFile || showPreviewFromPath;
                      final isPdf = _isPdfPath(path);
                      final pdfThumbnail =
                          isPdf ? _pdfThumbnailBytes[path] : null;
                      final showPdfPreview = isPdf && pdfThumbnail != null;
                      final showThumbnail = showImagePreview || showPdfPreview;
                      final pdfThumbnailLoading = isPdf && pdfThumbnail == null;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final isExistingWithId =
                                  isExisting && existingMedia[index].id != null;
                              if (isExistingWithId) {
                                final result = await context
                                    .read<TransactionCubit>()
                                    .getFileContent(existingMedia[index].id!);
                                if (!mounted) return;
                                result.fold(
                                  (_) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        LocaleKeys.couldNotLoadAttachment.tr(),
                                      ),
                                    ),
                                  ),
                                  (filePath) => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => ViewAttachmentScreen(
                                        filePath: filePath,
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => ViewAttachmentScreen(
                                      filePath: path,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 72.w,
                              height: 72.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: showThumbnail
                                    ? (showPdfPreview
                                        ? Image.memory(
                                            pdfThumbnail,
                                            fit: BoxFit.cover,
                                          )
                                        : (loadedPath != null
                                            ? Image.file(
                                                File(loadedPath),
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                file,
                                                fit: BoxFit.cover,
                                              )))
                                    : isLoading || pdfThumbnailLoading
                                        ? Center(
                                            child: SizedBox(
                                              width: 24.w,
                                              height: 24.h,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  iconForAttachmentPath(path),
                                                  size: 28.sp,
                                                  color: Colors.grey.shade600,
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  name.length > 10
                                                      ? '${name.substring(0, 10)}…'
                                                      : name,
                                                  style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -6.h,
                            right: -6.w,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(
                                minWidth: 24.w,
                                minHeight: 24.h,
                              ),
                              icon: Icon(
                                Icons.cancel,
                                size: 24.sp,
                                color: widget.accentColor,
                              ),
                              onPressed: () async {
                                if (isExisting) {
                                  final result = await context
                                      .read<TransactionCubit>()
                                      .deleteMedia(path);
                                  if (!mounted) return;
                                  result.fold(
                                    (_) => null,
                                    (_) => setState(() {
                                      existingMedia = existingMedia
                                          .where((m) => m.path != path)
                                          .toList();
                                      if (mediaId != null) {
                                        _loadedMediaPaths.remove(mediaId);
                                        _failedMediaIds.remove(mediaId);
                                      }
                                    }),
                                  );
                                } else {
                                  setState(() {
                                    attachedFilePaths = List.from(
                                        attachedFilePaths)
                                      ..removeAt(index - existingMedia.length);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: 20.h),
              SizedBox(
                height: 54.h,
                width: double.infinity,
                child: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(widget.accentColor),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final amount = double.parse(amountController.text);
                          final description = descriptionController.text;

                          if (widget.transactionCompleteEntity != null) {
                            context.read<TransactionCubit>().updateTransaction(
                                  id: widget.transactionCompleteEntity!
                                      .transaction.clientId,
                                  amount: amount,
                                  description: description,
                                  datetime: date,
                                  categoryIds: _selectedCategory != null
                                      ? [_selectedCategory!.clientId]
                                      : [],
                                  partyClientId: _selectedParty?.clientId,
                                  attachedFilePaths: attachedFilePaths,
                                );
                            // Navigation handled by BlocListener
                          } else {
                            context.read<TransactionCubit>().addTransaction(
                                  amount: amount,
                                  description: description,
                                  categoryIds: _selectedCategory != null
                                      ? [_selectedCategory!.clientId]
                                      : [],
                                  type: widget.transactionType,
                                  datetime: date,
                                  walletClientId:
                                      _selectedWallet?.clientId ?? '',
                                  partyClientId: _selectedParty?.clientId,
                                  attachedFilePaths: attachedFilePaths,
                                );
                            // Navigation handled by BlocListener
                          }
                        }
                      },
                      child: Row(
                        spacing: 8.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.transactionCompleteEntity != null
                                ? (widget.transactionType ==
                                        TransactionType.income
                                    ? LocaleKeys.updateIncome.tr()
                                    : LocaleKeys.updateExpenses.tr())
                                : widget.transactionType ==
                                        TransactionType.income
                                    ? LocaleKeys.transactionRecordIncome.tr()
                                    : LocaleKeys.transactionRecordExpenses.tr(),
                          ),
                          SvgPicture.asset(
                            Assets.images.add,
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
