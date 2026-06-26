import '../../../api/dummyjson_client.dart';
import '../domain/todo_entity.dart';
import '../domain/todo_repository.dart';

/// 데이터 레이어 구현: dummyjson 클라이언트로 할일을 가져와 도메인 엔티티로 변환한다.
///
/// API 의 Todo(DTO) → TodoEntity(도메인) 매핑이 여기서 일어난다.
/// 도메인은 이 클래스(구현)를 모르고, 추상 TodoRepository 만 안다.
class TodoRepositoryImpl implements TodoRepository {
  TodoRepositoryImpl(this._client);

  final DummyJsonClient _client;

  @override
  Future<List<TodoEntity>> getTodos() async {
    final todos = await _client.fetchTodos(limit: 8); // DTO 목록
    // DTO → 도메인 엔티티 매핑
    return todos
        .map((t) => TodoEntity(id: t.id, title: t.todo, done: t.completed))
        .toList();
  }
}
