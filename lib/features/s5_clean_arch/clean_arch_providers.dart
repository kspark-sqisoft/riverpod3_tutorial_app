import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/api_providers.dart';
import 'data/todo_repository_impl.dart';
import 'domain/todo_entity.dart';
import 'domain/todo_repository.dart';

part 'clean_arch_providers.g.dart';

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
