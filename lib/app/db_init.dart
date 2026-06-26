// 플랫폼에 따라 알맞은 initDatabaseFactory 구현을 가져온다.
// - dart:io 가 있으면(데스크톱/모바일) db_init_ffi.dart
// - 없으면(웹) db_init_stub.dart (no-op)
export 'db_init_stub.dart' if (dart.library.io) 'db_init_ffi.dart';
