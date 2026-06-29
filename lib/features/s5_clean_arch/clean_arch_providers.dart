import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/api_providers.dart';
import 'data/in_memory_todo_repository.dart';
import 'data/todo_repository_impl.dart';
import 'domain/local_todo_repository.dart';
import 'domain/todo_entity.dart';
import 'domain/todo_repository.dart';
import 'domain/todo_usecases.dart';

part 'clean_arch_providers.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 로컬 인메모리 CRUD (완전한 클린 아키텍처 예제)
//   data        : InMemoryTodoRepository (LocalTodoRepository 구현)
//   domain      : LocalTodoRepository(추상) · GetTodos/AddTodo/ToggleTodo/DeleteTodo(유스케이스)
//   presentation: TodoListController(AsyncNotifier) → UI
//   DI 배선      : 아래 provider 들이 "등록", 컨트롤러가 ref.watch 로 "주입"받는다.
// ─────────────────────────────────────────────────────────────────────────────

/// DI ①: 추상 [LocalTodoRepository] 를 인메모리 구현으로 연결(여기만 구현을 안다).
/// keepAlive: 화면을 떠나도 추가한 할일이 사라지지 않게 메모리를 유지.
/// 테스트에서는 이 provider 만 override 하면 저장소를 통째로 바꿀 수 있다.
@Riverpod(keepAlive: true)
LocalTodoRepository localTodoRepository(Ref ref) => InMemoryTodoRepository();

/// DI ②: 유스케이스 — 저장소(추상)를 주입해 만든다. 컨트롤러는 이 유스케이스에만 의존.
@riverpod
GetTodos getTodos(Ref ref) => GetTodos(ref.watch(localTodoRepositoryProvider));
@riverpod
AddTodo addTodo(Ref ref) => AddTodo(ref.watch(localTodoRepositoryProvider));
@riverpod
ToggleTodo toggleTodo(Ref ref) =>
    ToggleTodo(ref.watch(localTodoRepositoryProvider));
@riverpod
DeleteTodo deleteTodo(Ref ref) =>
    DeleteTodo(ref.watch(localTodoRepositoryProvider));

/// DI ③(프레젠테이션): 화면 상태를 들고 유스케이스를 호출하는 컨트롤러.
///
/// build() 는 GetTodos 로 목록을 읽어 `AsyncValue<List<TodoEntity>>` 로 노출하고,
/// add/toggle/remove 는 해당 유스케이스를 호출한 뒤 invalidateSelf 로 목록을 다시 읽는다.
/// (화면은 이 컨트롤러만 watch 하면 되고, 저장소/구현은 전혀 모른다.)
@riverpod
class TodoListController extends _$TodoListController {
  @override
  Future<List<TodoEntity>> build() => ref.watch(getTodosProvider).call();

  Future<void> add(String title) async {
    await ref.read(addTodoProvider).call(title); // 도메인 규칙(공백 거부)은 유스케이스가 처리
    ref.invalidateSelf(); // 저장소가 바뀌었으니 목록을 다시 읽는다
    await future;
  }

  Future<void> toggle(int id) async {
    await ref.read(toggleTodoProvider).call(id);
    ref.invalidateSelf();
    await future;
  }

  Future<void> remove(int id) async {
    await ref.read(deleteTodoProvider).call(id);
    ref.invalidateSelf();
    await future;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 원격(HTTP) 구현 예제 — 같은 클린 아키텍처의 "다른 data 레이어".
// (토픽 20 테스트에서 todoRepository 를 override 해 검증한다.)
// ─────────────────────────────────────────────────────────────────────────────

/// DI 배선 ①: 추상 [TodoRepository] 를 실제 구현으로 연결한다.
///
/// "여기"가 유일하게 구현(TodoRepositoryImpl)을 아는 지점이다.
/// 테스트/데모에서는 이 provider 만 override 하면 구현을 통째로 바꿀 수 있다(토픽 15).
@riverpod
TodoRepository todoRepository(Ref ref) =>
    TodoRepositoryImpl(ref.watch(dummyJsonClientProvider));

/// DI 배선 ②: 컨트롤러(프레젠테이션)는 추상 타입에만 의존한다.
///
/// repo 의 실제 구현이 무엇인지 모른 채 getTodos() 만 호출 → 결합도가 낮다.
@riverpod
Future<List<TodoEntity>> cleanTodos(Ref ref) {
  final repo = ref.watch(todoRepositoryProvider); // 추상 타입 주입
  return repo.getTodos();
}
