import 'todo_entity.dart';

/// 추상 리포지토리(도메인 인터페이스).
///
/// "할일을 어떻게 가져오는가"의 계약만 정의하고, 구현(HTTP/로컬 등)은 data 레이어에 맡긴다.
/// UI/도메인은 이 추상 타입에만 의존하므로 구현을 자유롭게 교체할 수 있다(의존성 역전).
abstract interface class TodoRepository {
  Future<List<TodoEntity>> getTodos();
}
