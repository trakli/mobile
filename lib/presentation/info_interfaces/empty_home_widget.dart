import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/utils/colors.dart';

class EmptyHomeWidget extends StatefulWidget {
  const EmptyHomeWidget({super.key});

  @override
  State<EmptyHomeWidget> createState() => _EmptyHomeWidgetState();
}

class _EmptyHomeWidgetState extends State<EmptyHomeWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_PageData> _pages = [
    _PageData(
      title: "Add Your First Transaction",
      description:
          "Start your financial journey by recording a transaction. This is the heart of expense tracking!",
      points: [
        "See your balance change in real-time",
        "Get instant insights into your spending",
        "Start building healthy money habits",
      ],
      icon: Icons.compare_arrows_outlined,
      buttonText: "Add Transaction",
    ),
    _PageData(
      title: "Set Your Budgets",
      description:
          "Plan your spending and stay in control by creating custom budgets for different categories.",
      points: [
        "Avoid overspending",
        "Track category limits",
        "Stay aligned with your goals",
      ],
      icon: Icons.pie_chart_outline,
      buttonText: "Create Budget",
    ),
    _PageData(
      title: "View Smart Reports",
      description:
          "Gain powerful insights into your finances with our visual analytics and charts.",
      points: [
        "Identify spending patterns",
        "Spot growth opportunities",
        "See where your money goes",
      ],
      icon: Icons.bar_chart_rounded,
      buttonText: "View Reports",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    return Column(
      children: [
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: appPrimaryColor.withAlpha(40),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(Icons.waving_hand_outlined,
                  color: Colors.green.shade700, size: 26.sp),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${LocaleKeys.homeWelcome.tr()}, ${user?.firstName ?? ""}",
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),
                    Text(
                      LocaleKeys.financeInfo.tr(),
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 18.h),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: appPrimaryColor,
              dotColor: Colors.green.shade200,
              dotHeight: 8.h,
              dotWidth: 8.h,
              expansionFactor: 3,
              spacing: 6.w,
            ),
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final data = _pages[index];
              return _buildPage(data);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPage(_PageData data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.sp,
            backgroundColor: appPrimaryColor.withAlpha(30),
            child: Icon(
              data.icon,
              size: 28.sp,
              color: appPrimaryColor,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
          ),
          SizedBox(height: 30.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Why This Matters:",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: appPrimaryColor,
                  ),
                ),
                SizedBox(height: 16.h),
                ...data.points.map(
                  (p) => _buildPoint(
                    icon: FontAwesomeIcons.bullseye,
                    text: p,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: Text(
                data.buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPoint({required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green.shade600, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 13.5.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  final String title;
  final String description;
  final List<String> points;
  final IconData icon;
  final String buttonText;

  _PageData({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.buttonText,
  });
}
