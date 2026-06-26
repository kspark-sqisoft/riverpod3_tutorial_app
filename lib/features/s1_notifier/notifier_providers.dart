import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier_providers.g.dart';

/// 할일 1개를 나타내는 불변(immutable) 모델.
/// 상태를 "새 객체로 교체"하는 방식이 Riverpod 의 권장 패턴이다.
class TodoItem {
  const TodoItem({required this.id, required this.title, this.done = false});

  final int id;
  final String title;
  final bool done;

  // 일부 필드만 바꾼 새 객체를 만든다(불변 업데이트).
  TodoItem copyWith({bool? done}) =>
      TodoItem(id: id, title: title, done: done ?? this.done);
}

/// NotifierProvider(코드생성 클래스형): 동기 상태(할일 목록)를 관리한다.
///
/// - build(): 초기 상태를 반환(여기서 호출되는 시점이 Alive 의 시작)
/// - 메서드에서 state 에 "새 리스트"를 대입하면 구독 위젯이 자동 갱신된다.
///   (기존 리스트를 직접 mutate 하면 변경 감지가 안 되므로 항상 새로 만든다.)
@riverpod
class TodoList extends _$TodoList {
  @override
  List<TodoItem> build() => const [
        TodoItem(id: 1, title: 'Riverpod 기본 익히기'),
        TodoItem(id: 2, title: 'Notifier 로 상태 바꾸기', done: true),
      ];

  // 새 할일 추가
  void add(String title) {
    final nextId =
        state.isEmpty ? 1 : state.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    state = [...state, TodoItem(id: nextId, title: title)]; // 새 리스트로 교체
  }

  // 완료/미완료 토글
  void toggle(int id) {
    state = [
      for (final t in state)
        if (t.id == id) t.copyWith(done: !t.done) else t,
    ];
  }

  // 삭제
  void remove(int id) {
    state = state.where((t) => t.id != id).toList();
  }
}
