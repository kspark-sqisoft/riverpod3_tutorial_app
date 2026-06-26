import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'notifier_providers.dart';

/// 토픽 3: NotifierProvider — 동기 상태(할일 목록) 관리.
class NotifierPage extends ConsumerWidget {
  const NotifierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider); // 할일 목록 구독

    return ConceptPage(
      title: '3. NotifierProvider',
      explanation:
          'NotifierProvider 는 상태와 그 상태를 바꾸는 메서드를 함께 담는 가장 기본적인 '
          '"쓰기 가능" provider 입니다. 코드생성에서는 _\$클래스명 을 상속한 클래스에 '
          'build() 로 초기 상태를 정의하고, 메서드에서 state 를 새 값으로 교체합니다.',
      points: const [
        'build(): 초기 상태 반환 (provider 가 Alive 가 되는 시작점)',
        'state = 새값: 대입하면 구독자가 자동으로 다시 그려짐',
        '불변 업데이트: 리스트/객체는 직접 수정하지 말고 새로 만들어 교체',
        'UI에서 메서드 호출은 ref.read(todoListProvider.notifier).add(...)',
      ],
      demo: _TodoDemo(todos: todos),
      snippets: const [
        CodeSnippet(title: 'notifier_providers.dart', code: _code),
      ],
    );
  }
}

class _TodoDemo extends ConsumerStatefulWidget {
  const _TodoDemo({required this.todos});
  final List<TodoItem> todos;

  @override
  ConsumerState<_TodoDemo> createState() => _TodoDemoState();
}

class _TodoDemoState extends ConsumerState<_TodoDemo> {
  final _controller = TextEditingController(); // 입력 필드 컨트롤러

  @override
  void dispose() {
    _controller.dispose(); // 위젯 폐기 시 컨트롤러 정리
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    // read: 버튼 콜백에서 notifier 의 add 호출
    ref.read(todoListProvider.notifier).add(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 입력 + 추가 버튼
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '할 일을 입력하세요',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _add, child: const Text('추가')),
              ],
            ),
            const SizedBox(height: 12),
            // 목록
            for (final todo in widget.todos)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Checkbox(
                  value: todo.done,
                  // 체크 토글 → notifier.toggle
                  onChanged: (_) =>
                      ref.read(todoListProvider.notifier).toggle(todo.id),
                ),
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.done ? TextDecoration.lineThrough : null,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  // 삭제 → notifier.remove
                  onPressed: () =>
                      ref.read(todoListProvider.notifier).remove(todo.id),
                ),
              ),
            if (widget.todos.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('할 일이 없습니다. 추가해 보세요!'),
              ),
          ],
        ),
      ),
    );
  }
}

const String _code = r'''
@riverpod
class TodoList extends _$TodoList {
  @override
  List<TodoItem> build() => const [ /* 초기 목록 */ ];

  void add(String title) {
    state = [...state, TodoItem(id: nextId, title: title)]; // 새 리스트로 교체
  }
  void toggle(int id) {
    state = [for (final t in state) if (t.id == id) t.copyWith(done: !t.done) else t];
  }
  void remove(int id) => state = state.where((t) => t.id != id).toList();
}
''';
