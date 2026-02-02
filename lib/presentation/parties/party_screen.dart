import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trakli/core/constants/ui_constants.dart';
import 'package:trakli/domain/entities/party_entity.dart';
import 'package:trakli/gen/translations/codegen_loader.g.dart';
import 'package:trakli/presentation/info_interfaces/data.dart';
import 'package:trakli/presentation/info_interfaces/info_interface.dart';
import 'package:trakli/presentation/parties/add_party_screen.dart';
import 'package:trakli/presentation/parties/cubit/party_cubit.dart';
import 'package:trakli/presentation/transactions/cubit/transaction_cubit.dart';
import 'package:trakli/presentation/utils/app_navigator.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/education_banner.dart';
import 'package:trakli/presentation/utils/enums.dart';
import 'package:trakli/presentation/utils/party_card.dart';

class PartyScreen extends StatefulWidget {
  const PartyScreen({super.key});

  @override
  State<PartyScreen> createState() => _PartyScreenState();
}

class _PartyScreenState extends State<PartyScreen> {
  bool _bannerDismissed = false;

  void addAction() {
    AppNavigator.push(context, const AddPartyScreen());
  }

  Map<String, PartyStats> _computePartyStats(
    List<PartyEntity> parties,
    TransactionState transactionState,
  ) {
    final stats = <String, PartyStats>{};

    for (final party in parties) {
      double received = 0;
      double spent = 0;

      for (final txn in transactionState.transactions) {
        if (txn.party?.clientId == party.clientId) {
          final amount = txn.transaction.amount;
          if (txn.transaction.type == TransactionType.income) {
            received += amount;
          } else {
            spent += amount;
          }
        }
      }

      stats[party.clientId] = PartyStats(
        receivedAmount: received,
        spentAmount: spent,
      );
    }

    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PartyCubit, PartyState>(
      builder: (context, partyState) {
        return BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, transactionState) {
            final partyStats = _computePartyStats(
              partyState.parties,
              transactionState,
            );

            return Scaffold(
              appBar: CustomAppBar(
                backgroundColor: Theme.of(context).primaryColor,
                leading: const CustomBackButton(),
                titleText: LocaleKeys.parties.tr(),
                headerTextColor: const Color(0xFFEBEDEC),
                actions: [
                  InkWell(
                    onTap: () {
                      addAction();
                    },
                    child: Container(
                      width: 42.r,
                      height: 42.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      padding: EdgeInsets.all(8.r),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          size: 24.r,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
              body: partyState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : partyState.parties.isEmpty
                      ? InfoInterface(
                          action: () {
                            addAction();
                          },
                          data: emptyPartyData,
                        )
                      : SingleChildScrollView(
                          padding: EdgeInsets.all(16.r),
                          child: Column(
                            children: [
                              if (partyState.parties.length <
                                      UiConstants.educationBannerThreshold &&
                                  !_bannerDismissed)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: EducationBanner(
                                    message:
                                        LocaleKeys.partyEducationBanner.tr(),
                                    icon: Icons.people_outline,
                                    onDismiss: () {
                                      setState(() {
                                        _bannerDismissed = true;
                                      });
                                    },
                                  ),
                                ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final cardWidth =
                                      (constraints.maxWidth - 12.w) / 2;
                                  return Wrap(
                                    spacing: 12.w,
                                    runSpacing: 12.h,
                                    children: partyState.parties.map((party) {
                                      final stats = partyStats[party.clientId];
                                      return SizedBox(
                                        width: cardWidth,
                                        child: PartyCard(
                                          party: party,
                                          receivedAmount:
                                              stats?.receivedAmount ?? 0,
                                          spentAmount: stats?.spentAmount ?? 0,
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
            );
          },
        );
      },
    );
  }
}

class PartyStats {
  final double receivedAmount;
  final double spentAmount;

  const PartyStats({
    required this.receivedAmount,
    required this.spentAmount,
  });
}
