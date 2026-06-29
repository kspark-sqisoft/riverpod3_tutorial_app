import 'todo_entity.dart';

/// 로컬 할일 저장소(도메인 인터페이스).
///
/// "할일을 어떻게 저장/조회/변경하는가"의 계약(CRUD)만 정의한다.
/// 실제 구현(인메모리/sqflite/HTTP 등)은 data 레이어에 두고, 도메인/프레젠테이션은
/// 이 추상 타입에만 의존한다(의존성 역전 — 구현을 자유롭게 교체).
abstract interface class LocalTodoRepository {
  Future<List<TodoEntity>> getAll();
  Future<TodoEntity> add(String title);
  Future<void> toggle(int id);
  Future<void> remove(int id);
}
