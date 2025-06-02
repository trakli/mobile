import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trakli/core/error/failures/failures.dart';
import 'package:trakli/domain/entities/wallet_entity.dart';
import 'package:trakli/presentation/utils/back_button.dart';
import 'package:trakli/presentation/utils/custom_appbar.dart';
import 'package:trakli/presentation/utils/forms/add_wallet_form.dart';
import 'package:trakli/presentation/wallets/cubit/wallet_cubit.dart';

class AddWalletScreen extends StatelessWidget {
  final WalletEntity? wallet;

  const AddWalletScreen({
    super.key,
    this.wallet,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state.failure != const Failure.none()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.customMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          backgroundColor: Theme.of(context).primaryColor,
          headerTextColor: Colors.white,
          titleText: wallet != null ? "Edit wallet" : "Add wallet",
          leading: const CustomBackButton(),
        ),
        body: AddWalletForm(wallet: wallet),
      ),
    );
  }
}
