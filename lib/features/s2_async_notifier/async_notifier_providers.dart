import 'package:riverpod_annotation/riverpod_annotation.dart'; // @riverpod, AsyncValue 등 re-export

import '../../api/api_providers.dart';
import '../../api/models/todo.dart';
import '../../shared/app_logger.dart';

part 'async_notifier_providers.g.dart';

/// AsyncNotifierProvider: 비동기 초기 로딩 + 상태 변경 메서드를 함께 갖는다.
///
/// build() 가 Future 를 반환하면 상태 타입은 `AsyncValue<List<Todo>>` 가 된다.
/// 메서드에서 state 를 AsyncData/AsyncLoading 으로 바꿔 UI 를 제어한다.
@riverpod
class TodosController extends _$TodosController {
  @override
  Future<List<Todo>> build() async {
    final client = ref.watch(dummyJsonClientProvider); // 클라이언트 주입
    return client.fetchTodos(limit: 10); // 초기 비동기 로딩
  }

  /// 낙관적 토글: 서버 응답을 기다리지 않고 먼저 화면을 바꾼다.
  /// (dummyjson 은 실제 저장하지 않으므로 여기선 로컬 상태만 갱신)
  void toggle(int id) {
    final current = state.value ?? const <Todo>[]; // 현재 데이터(없으면 빈 목록)
    state = AsyncData([
      for (final t in current)
        if (t.id == id) t.copyWith(completed: !t.completed) else t,
    ]);
    log.d('✅ 낙관적 토글: id=$id');
  }

  /// 추가: 서버 호출 → 결과를 목록 맨 앞에 반영.
  /// AsyncValue.guard 는 try/catch 를 대신해 에러를 AsyncError 로 잡아준다.
  /// (await 동안 화면은 이전 데이터를 그대로 유지한다.)
  Future<void> add(String title) async {
    final client = ref.read(dummyJsonClientProvider);
    final current = state.value ?? const <Todo>[]; // 추가 전 현재 목록
    state = await AsyncValue.guard(() async {
      final created = await client.addTodo(todo: title);
      return [created, ...current]; // 맨 앞에 추가
    });
  }

  /// 새로고침: 자기 자신을 무효화하고 새 데이터를 기다린다.
  Future<void> refresh() async {
    ref.invalidateSelf(); // 다음 read 때 build 재실행
    await future; // 새 build 의 Future 완료 대기
  }

  /// AsyncValue.guard 시연: try/catch 없이 에러를 AsyncError 로 변환한다.
  ///
  /// 콜백이 예외를 던지면 guard 가 잡아 state 를 AsyncError 로 만들어 주므로,
  /// 직접 try/catch 로 상태를 만들 필요가 없다. (성공 시 AsyncData)
  Future<void> simulateError() async {
    state = const AsyncLoading<List<Todo>>(); // 로딩 표시
    state = await AsyncValue.guard(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      throw Exception('의도적 에러 — guard 가 AsyncError 로 변환'); // 던지면 guard 가 캡처
    });
  }
}
