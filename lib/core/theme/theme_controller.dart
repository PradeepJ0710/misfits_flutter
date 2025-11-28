import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeController extends AsyncNotifier<ThemeMode> {
  static const String _kThemeKey = 'theme_mode';
  final _storage = const FlutterSecureStorage();

  @override
  Future<ThemeMode> build() async {
    final themeStr = await _storage.read(key: _kThemeKey);
    if (themeStr == 'dark') {
      return ThemeMode.dark;
    } else if (themeStr == 'light') {
      return ThemeMode.light;
    }
    return ThemeMode.dark; // Default to dark
  }

  Future<void> toggleTheme() async {
    final current = state.value ?? ThemeMode.dark;
    final newTheme = current == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;

    state = AsyncData(newTheme);

    await _storage.write(
      key: _kThemeKey,
      value: newTheme == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}

final themeControllerProvider =
    AsyncNotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
