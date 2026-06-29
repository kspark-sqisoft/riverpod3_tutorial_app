import 'local_todo_repository.dart';
import 'todo_entity.dart';

/// 유스케이스(애플리케이션 규칙): "하나의 동작"을 캡슐화한다.
///
/// 컨트롤러(프레젠테이션)는 저장소를 직접 다루지 않고 유스케이스를 호출한다.
/// 검증 같은 "비즈니스 규칙"을 여기에 모아 화면·저장소와 분리한다(테스트도 쉬움).

/// 할일 목록 조회.
class GetTodos {
  const GetTodos(this._repo);
  final LocalTodoRepository _repo;

  Future<List<TodoEntity>> call() => _repo.getAll();
}

/// 할일 추가 — 공백 제목은 거부하는 도메인 규칙을 담는다.
class AddTodo {
  const AddTodo(this._repo);
  final LocalTodoRepository _repo;

  Future<TodoEntity> call(String title) {
    final trimmed = title.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('할일 제목은 비어 있을 수 없습니다');
    }
    return _repo.add(trimmed);
  }
}

/// 완료/미완료 토글.
class ToggleTodo {
  const ToggleTodo(this._repo);
  final LocalTodoRepository _repo;

  Future<void> call(int id) => _repo.toggle(id);
}

/// 할일 삭제.
class DeleteTodo {
  const DeleteTodo(this._repo);
  final LocalTodoRepository _repo;

  Future<void> call(int id) => _repo.remove(id);
}
