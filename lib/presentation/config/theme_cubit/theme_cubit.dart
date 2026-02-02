import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/core/constants/config_constants.dart';
import 'package:trakli/di/injection.dart';
import 'package:trakli/domain/entities/config_entity.dart';
import 'package:trakli/presentation/config/cubit/config_cubit.dart';

@lazySingleton
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void updateThemeByEnum(ThemeMode mode) {
    final configCubit = getIt<ConfigCubit>();
    configCubit.saveConfig(
      key: ConfigConstants.theme,
      type: ConfigType.string,
      value: mode.name,
    );
    emit(mode);
  }

  void updateThemeByString(String themeName) {
    try {
      final ThemeMode mode = ThemeMode.values.byName(themeName.toLowerCase());
      emit(mode);
    } catch (e) {
      emit(ThemeMode.light);
    }
  }
}
