/// 웹 등 dart:io(ffi)가 없는 플랫폼용 no-op 구현.
/// (웹에서는 sqflite ffi 초기화가 필요 없거나 불가하므로 아무것도 하지 않는다.)
void initDatabaseFactory() {}
