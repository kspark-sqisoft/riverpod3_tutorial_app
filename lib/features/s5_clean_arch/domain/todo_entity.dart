/// 도메인 엔티티: 앱 내부에서 쓰는 순수한 할일 모델.
///
/// API 의 DTO(api/models/todo.dart)와 분리한다. 도메인은 Flutter/HTTP/JSON 을
/// 전혀 모르게 두어, 데이터 출처가 바뀌어도 도메인/화면은 영향받지 않게 한다.
class TodoEntity {
  const TodoEntity({required this.id, required this.title, required this.done});

  final int id;
  final String title;
  final bool done;
}
