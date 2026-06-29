import '../domain/local_todo_repository.dart';
import '../domain/todo_entity.dart';

/// 데이터 레이어 구현: 앱 메모리에만 저장하는 로컬 저장소.
///
/// 도메인의 [LocalTodoRepository] 계약을 구현한다. 나중에 sqflite/HTTP 구현으로 바꿔도
/// 인터페이스가 같으므로 도메인/프레젠테이션 코드는 한 줄도 바뀌지 않는다(DI 한 곳만 교체).
class InMemoryTodoRepository implements LocalTodoRepository {
  // 초기 시드 데이터. 실제 앱에선 빈 목록이거나 영속 저장소에서 읽어온다.
  final List<TodoEntity> _todos = [
    const TodoEntity(id: 1, title: 'Riverpod 클린 아키텍처 이해하기', done: true),
    const TodoEntity(id: 2, title: '로컬 Todo 앱 만들기', done: false),
  ];
  int _nextId = 3;

  @override
  Future<List<TodoEntity>> getAll() async =>
      List.unmodifiable(_todos); // 외부에서 직접 못 바꾸게 불변 뷰 반환

  @override
  Future<TodoEntity> add(String title) async {
    final todo = TodoEntity(id: _nextId++, title: title, done: false);
    _todos.add(todo);
    return todo;
  }

  @override
  Future<void> toggle(int id) async {
    final i = _todos.indexWhere((t) => t.id == id);
    if (i != -1) _todos[i] = _todos[i].copyWith(done: !_todos[i].done);
  }

  @override
  Future<void> remove(int id) async => _todos.removeWhere((t) => t.id == id);
}
