// 토픽 20 실습: ProviderContainer.test() + override 로 provider 를 검증한다.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod3_tutorial_app/features/s1_notifier/notifier_providers.dart';
import 'package:riverpod3_tutorial_app/features/s5_clean_arch/clean_arch_providers.dart';
import 'package:riverpod3_tutorial_app/features/s5_clean_arch/domain/todo_entity.dart';
import 'package:riverpod3_tutorial_app/features/s5_clean_arch/domain/todo_repository.dart';

/// 테스트용 가짜 repository — 네트워크 없이 고정 데이터 반환.
class _FakeRepo implements TodoRepository {
  @override
  Future<List<TodoEntity>> getTodos() async =>
      const [TodoEntity(id: 1, title: 'fake', done: false)];
}

void main() {
  test('TodoList: add 하면 항목이 늘어난다', () {
    // 격리된 컨테이너(테스트 끝에 자동 dispose)
    final container = ProviderContainer.test();

    expect(container.read(todoListProvider).length, 2); // 초기 2개
    container.read(todoListProvider.notifier).add('새 할일');
    expect(container.read(todoListProvider).length, 3); // 추가 후 3개
  });

  test('TodoList: toggle 하면 완료 상태가 뒤집힌다', () {
    final container = ProviderContainer.test();
    final first = container.read(todoListProvider).first;
    container.read(todoListProvider.notifier).toggle(first.id);
    final toggled = container.read(todoListProvider).firstWhere((t) => t.id == first.id);
    expect(toggled.done, !first.done);
  });

  test('cleanTodos: repository 를 override 해 가짜 데이터 주입', () async {
    final container = ProviderContainer.test(
      overrides: [todoRepositoryProvider.overrideWithValue(_FakeRepo())],
    );

    // 비동기 provider 는 .future 로 결과를 기다린다.
    final todos = await container.read(cleanTodosProvider.future);
    expect(todos, hasLength(1));
    expect(todos.single.title, 'fake');
  });
}
