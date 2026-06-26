import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// 데스크톱(Windows/Linux/macOS)에서 sqflite 를 쓰려면 ffi 초기화가 필요하다.
/// (모바일은 기본 native factory 를 그대로 쓰므로 아무것도 하지 않는다.)
void initDatabaseFactory() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit(); // ffi 로더 초기화
    databaseFactory = databaseFactoryFfi; // 전역 factory 교체
  }
}
