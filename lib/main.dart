import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/database/sync_database.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/presentation/bloc/transaction/transaction_cubit.dart';
import 'presentation/screens/transaction_screen.dart';

/// Main entry point for the app
///
/// Calls the `bootstrap` function from `bootstrap.dart` to initialize the app.
///
/// The `bootstrap` function ensures that the app is initialized correctly by:
///
/// - Setting a global error handler that logs errors and their stack traces to the console.
/// - Initializing the Flutter app by calling [WidgetsFlutterBinding.ensureInitialized].
/// - Running the app in a zone guarded against errors.
/// - Running the app by calling the provided `builder` function.
void main() {
  configureDependencies(Environment.dev);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TransactionCubit>(),
        )
      ],
      child: const MyAppView(),
    );
  }
}

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  @override
  void initState() {
    super.initState();
    getIt<SynchAppDatabase>().sync();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trakli',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const TransactionScreen(),
    );
  }
}
