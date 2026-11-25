import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trakli/presentation/utils/design_tokens.dart';
import 'package:trakli/presentation/utils/ledger/ledger_type.dart';
import 'package:trakli/presentation/utils/ledger/ledger_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/add_transaction_screen.dart';
import 'package:trakli/presentation/auth/cubits/auth/auth_cubit.dart';
import 'package:trakli/presentation/category/category_screen.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/empty_data_model.dart';
import 'package:trakli/presentation/parties/party_screen.dart';
import 'package:trakli/presentation/root/bloc/main_navigation_page_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';

class EmptyHomeWidget extends StatefulWidget {
  const EmptyHomeWidget({super.key});

  @override
  State<EmptyHomeWidget> createState() => _EmptyHomeWidgetState();
}

class _EmptyHomeWidgetState extends State<EmptyHomeWidget> {
  final PageController _pageController = PageController();
  late Timer _timer;
  int _currentIndex = 0;
  final int _numPages = 5;

  final List<EmptyStateModel> _pages = [
    emptyTransactionData,
    emptyWalletData,
    emptyCategoryData,
    emptyPartyData,
    youAllSetData,
  ];

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentIndex < _numPages - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }

      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user;
    final t = context.tones;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(14.lx, 8.lx, 14.lx, 0),
          child: LedgerCard(
            child: Row(
              children: [
                const LedgerCoin(icon: LucideIcons.hand, size: 40),
                SizedBox(width: 12.lx),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${LocaleKeys.homeWelcome.tr()}, ${user?.firstName ?? ""}",
                        style: TextStyle(
                          fontSize: 16.lx,
                          fontWeight: FontWeight.w700,
                          color: t.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.lx),
                      Text(
                        LocaleKeys.financeInfo.tr(),
                        style: TextStyle(fontSize: 12.5.lx, color: t.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 14.lx),
          child: SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: t.brandFill,
              dotColor: t.surface3,
              dotHeight: 6.lx,
              dotWidth: 6.lx,
              expansionFactor: 3,
              spacing: 5.lx,
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
            itemBuilder: (context, index) => _buildPage(_pages[index]),
          ),
        ),
      ],
    );
  }

  void _act() {
    final cubit = context.read<MainNavigationCubit>();
    switch (_currentIndex) {
      case 0:
        AppNavigator.push(context, const AddTransactionScreen());
      case 1:
        cubit.updateIndex(MainNavigationPageState.wallet);
      case 2:
        AppNavigator.push(context, const CategoryScreen());
      case 3:
        AppNavigator.push(context, const PartyScreen());
    }
  }

  Widget _buildPage(EmptyStateModel data) {
    final t = context.tones;
    return ListView(
      padding: EdgeInsets.fromLTRB(14.lx, 14.lx, 14.lx, 24.lx),
      children: [
        Align(child: LedgerCoin(icon: data.icon, size: 48)),
        SizedBox(height: 14.lx),
        Text(
          data.title1?.tr() ?? data.title.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18.lx,
            fontWeight: FontWeight.w700,
            color: t.textPrimary,
          ),
        ),
        SizedBox(height: 6.lx),
        Text(
          data.description1?.tr() ?? data.description.tr(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.lx,
            height: 1.45,
            color: t.textSecondary,
          ),
        ),
        SizedBox(height: 16.lx),
        if (data.quickSteps != null)
          LedgerCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LedgerH6(LocaleKeys.whyThisMatters.tr()),
                SizedBox(height: 10.lx),
                for (final p in data.quickSteps!)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.lx),
                    child: Row(
                      children: [
                        Icon(p.icon, color: t.brandText, size: 16.lx),
                        SizedBox(width: 10.lx),
                        Expanded(
                          child: Text(
                            p.description.tr(),
                            style: TextStyle(
                              fontSize: 13.lx,
                              color: t.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(height: 16.lx),
        if (data.buttonText.isNotEmpty)
          LedgerButton(
            label: data.buttonText1?.tr() ?? '',
            large: true,
            onPressed: _act,
          ),
      ],
    );
  }
}
