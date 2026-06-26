import 'package:flutter_riverpod/experimental/persist.dart'; // persist 확장(NotifierPersistX)
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';

part 'persistence_providers.g.dart';

/// SQLite 저장소를 여는 provider. 앱 전체가 공유하므로 keepAlive.
/// (데스크톱은 main 에서 ffi 초기화가 되어 있어야 동작한다.)
@Riverpod(keepAlive: true)
Future<JsonSqFliteStorage> storage(Ref ref) {
  return JsonSqFliteStorage.open('riverpod_tutorial.db');
}

/// 영속화되는 카운터. 앱을 껐다 켜도 값이 복원된다.
@riverpod
class PersistedCounter extends _$PersistedCounter {
  @override
  Future<int> build() async {
    // persist: 상태 변화를 자동으로 DB 에 저장하고, 첫 build 때 저장값을 복원한다.
    persist(
      ref.watch(storageProvider.future), // 저장소(Future 그대로 전달 가능)
      key: 'persisted_counter', // 이 상태를 식별하는 키
      encode: (state) => state.toString(), // int → String 직렬화
      decode: (encoded) => int.parse(encoded), // String → int 역직렬화
    );
    return 0; // 저장된 값이 없을 때의 기본값
  }

  Future<void> increment() async {
    final current = state.value ?? 0;
    state = AsyncData(current + 1); // 변경 시 persist 가 자동으로 DB 에 기록
  }

  Future<void> reset() async => state = const AsyncData(0);
}
