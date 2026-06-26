import 'package:flutter/material.dart';

/// 앱 전역 테마(Material 3, 라이트/다크).
///
/// seed color 하나로 ColorScheme 전체를 생성한다(Material 3 권장 방식).
class AppTheme {
  AppTheme._();

  static const Color _seed = Color(0xFF3A6EA5); // 시드 색상(차분한 블루)

  static ThemeData light() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _seed),
      );

  static ThemeData dark() => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      );
}
