import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/domain/entities/group_entity.dart';
import 'package:trakli/domain/entities/transaction_complete_entity.dart'
    show TransactionCompleteEntity;
import 'package:trakli/gen/assets.gen.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/groups/cubit/group_cubit.dart';
import 'package:trakli/presentation/history_screen.dart';
import 'package:trakli/presentation/notification_screen.dart';
import 'package:trakli/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/bottom_sheets/pick_group_bottom_sheet.dart';
import 'package:trakli/presentation/utils/colors.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/helpers.dart';
import 'package:trakli/presentation/utils/transaction_tile.dart';
import 'package:trakli/presentation/utils/wallet_tile.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  // GroupEntity? group;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wallets = context.watch<WalletCubit>().state.wallets;

    final groups = context.watch<GroupCubit>().state.groups;
    final defaultGroupId =
        context.watch<OnboardingCubit>().state.entity?.defaultGroup;

    final defaultGroup =
        groups.firstWhereOrNull((entity) => entity.clientId == defaultGroupId);

    final selectedGroup =
        context.watch<TransactionCubit>().state.selectedGroup ??
            defaultGroup ??
            groups.firstOrNull;

    final transactionGroup =
        context.watch<TransactionCubit>().state.selectedGroup;

    if (transactionGroup == null && selectedGroup != null) {
      context.watch<TransactionCubit>().setCurrentGroup(selectedGroup);
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: SvgPicture.asset(
          Assets.images.logoGreen,
          height: 38.h,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              AppNavigator.push(context, const NotificationScreen());
            },
            child: Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              ),
              // padding: EdgeInsets.all(14.r),
              child: Icon(
                Icons.notifications,
                size: 20.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(width: 16.w),
        ],
      ),
      body: BlocConsumer<TransactionCubit, TransactionState>(
        listenWhen: (previous, current) => previous.failure != current.failure,
        listener: (BuildContext context, TransactionState state) {
          if (state.failure.hasError) {
            showSnackBar(
              message: state.failure.customMessage,
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color>(appPrimaryColor),
              ),
            );
          }
          final transactions =
              wallets.isNotEmpty && currentIndex < wallets.length
                  ? state.transactions.where((transaction) {
                      return (transaction.wallet.clientId ==
                              wallets[currentIndex].clientId) &&
                          ((transaction.group?.clientId ==
                                  selectedGroup?.clientId) ||
                              (transaction.group?.clientId == null &&
                                  (selectedGroup?.clientId ==
                                      defaultGroup?.clientId)));
                    }).toList()
                  : <TransactionCompleteEntity>[];

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 15.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (wallets.isNotEmpty) ...[
                  CarouselSlider.builder(
                    options: CarouselOptions(
                      enableInfiniteScroll: false,
                      height: 190.h,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                    itemCount: wallets.length,
                    itemBuilder: (context, index, pageViewIndex) {
                      return WalletTile(
                        wallet: wallets[index],
                        canDelete: false,
                      );
                    },
                  ),
                  SizedBox(height: 12.h),
                  Align(
                    child: AnimatedSmoothIndicator(
                      activeIndex: currentIndex,
                      count: wallets.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: Theme.of(context).primaryColor,
                        dotWidth: 8.r,
                        dotHeight: 8.r,
                      ),
                    ),
                  ),
                ],
                Text(
                  LocaleKeys.transactions.tr(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        final groupEntity =
                            await showCustomBottomSheet<GroupEntity>(
                          context,
                          widget: PickGroupBottomSheet(
                            group: selectedGroup,
                          ),
                        );

                        if (mounted && groupEntity != null) {
                          setState(() {
                            // group = groupEntity;

                            context
                                .read<TransactionCubit>()
                                .setCurrentGroup(groupEntity);
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: appOrange.withAlpha(40),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Row(
                          spacing: 8.w,
                          children: [
                            SvgPicture.asset(
                              width: 16.w,
                              height: 16.h,
                              Assets.images.profile2user,
                              colorFilter: ColorFilter.mode(
                                appOrange,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              selectedGroup?.name ?? LocaleKeys.group.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SvgPicture.asset(
                              width: 16.w,
                              height: 16.h,
                              Assets.images.arrowRight,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        AppNavigator.push(context, const HistoryScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: seeAllBoxColor,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.all(8.r),
                        child: Row(
                          spacing: 8.w,
                          children: [
                            Text(
                              LocaleKeys.seeAll.tr(),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SvgPicture.asset(
                              width: 16.w,
                              height: 16.h,
                              Assets.images.arrowRight,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                transactions.isEmpty
                    ? SizedBox(
                        height: 0.25.sh,
                        child: Center(
                          child: Text(
                            LocaleKeys.noTransactionsFound.tr(),
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.grey),
                          ),
                        ),
                      )
                    : ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: transactions.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8.h);
                        },
                        itemBuilder: (context, index) {
                          final transaction = transactions[index];
                          return TransactionTile(
                            transaction: transaction,
                            accentColor: transaction.transaction.type ==
                                    TransactionType.income
                                ? Theme.of(context).primaryColor
                                : const Color(0xFFEB5757),
                          );
                        },
                      ),
                SizedBox(height: 28.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
