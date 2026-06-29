// 토픽 14 실습: 로컬 클린 아키텍처(유스케이스 단위 테스트 + 컨트롤러 테스트).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod3_tutorial_app/features/s5_clean_arch/clean_arch_providers.dart';
import 'package:riverpod3_tutorial_app/features/s5_clean_arch/domain/local_todo_repository.dart';
import 'package:riverpod3_tutorial_app/features/s5_clean_arch/domain/todo_entity.dart';
import 'package:riverpod3_tutorial_app/features/s5_clean_arch/domain/todo_usecases.dart';

/// 가짜 저장소 — 도메인 인터페이스만 구현. 네트워크/실DB 없이 검증한다.
class _FakeRepo implements LocalTodoRepository {
  final List<TodoEntity> _todos = [
    const TodoEntity(id: 1, title: 'seed', done: false),
  ];
  int _nextId = 2;

  @override
  Future<List<TodoEntity>> getAll() async => List.unmodifiable(_todos);

  @override
  Future<TodoEntity> add(String title) async {
    final t = TodoEntity(id: _nextId++, title: title, done: false);
    _todos.add(t);
    return t;
  }

  @override
  Future<void> toggle(int id) async {
    final i = _todos.indexWhere((t) => t.id == id);
    if (i != -1) _todos[i] = _todos[i].copyWith(done: !_todos[i].done);
  }

  @override
  Future<void> remove(int id) async => _todos.removeWhere((t) => t.id == id);
}

void main() {
  // 1) 유스케이스 단위 테스트 — 도메인 규칙(공백 제목 거부)
  test('AddTodo: 공백 제목은 ArgumentError 를 던진다', () {
    final add = AddTodo(_FakeRepo());
    expect(() => add('   '), throwsArgumentError);
  });

  test('AddTodo: 정상 제목은 추가된다', () async {
    final repo = _FakeRepo();
    await AddTodo(repo)('할일');
    final all = await GetTodos(repo)();
    expect(all.map((t) => t.title), contains('할일'));
  });

  // 2) 컨트롤러 테스트 — localTodoRepository 만 override 해 격리
  test('TodoListController: add 하면 목록이 늘어난다', () async {
    final container = ProviderContainer.test(
      overrides: [localTodoRepositoryProvider.overrideWithValue(_FakeRepo())],
    );

    final before = await container.read(todoListControllerProvider.future);
    await container.read(todoListControllerProvider.notifier).add('새 할일');
    final after = await container.read(todoListControllerProvider.future);

    expect(after.length, before.length + 1);
    expect(after.map((t) => t.title), contains('새 할일'));
  });

  test('TodoListController: toggle 하면 완료 상태가 뒤집힌다', () async {
    final container = ProviderContainer.test(
      overrides: [localTodoRepositoryProvider.overrideWithValue(_FakeRepo())],
    );

    final first =
        (await container.read(todoListControllerProvider.future)).first;
    await container.read(todoListControllerProvider.notifier).toggle(first.id);
    final toggled = (await container.read(todoListControllerProvider.future))
        .firstWhere((t) => t.id == first.id);

    expect(toggled.done, !first.done);
  });
}
