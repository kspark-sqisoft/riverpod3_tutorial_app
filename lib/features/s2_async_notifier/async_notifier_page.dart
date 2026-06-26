import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models/todo.dart';
import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'async_notifier_providers.dart';

/// 토픽 6: AsyncNotifierProvider — 비동기 로딩 + 상태 변경(CRUD/낙관적 업데이트).
class AsyncNotifierPage extends ConsumerWidget {
  const AsyncNotifierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(todosControllerProvider);

    return ConceptPage(
      title: '6. AsyncNotifierProvider',
      explanation:
          'AsyncNotifier 는 "비동기 초기 로딩 + 상태 변경 메서드"를 한 클래스에 담습니다. '
          'build() 가 Future 를 반환하면 상태는 AsyncValue 가 되고, 메서드에서 '
          'AsyncData/AsyncLoading 으로 state 를 갱신합니다. 추가/토글 같은 변경에서 '
          '낙관적 업데이트(먼저 화면 반영), AsyncValue.guard(에러 자동 처리), '
          'copyWithPrevious(이전 데이터 유지) 패턴을 자주 씁니다.',
      points: const [
        'build() 가 Future 반환 → 상태 타입은 AsyncValue<T>',
        '낙관적 업데이트: 서버 응답 전에 state 를 먼저 바꿔 즉각 반응',
        'AsyncValue.guard: try/catch 없이 에러를 AsyncError 로 캡처',
        'ref.invalidateSelf() + await future: 새로고침 패턴',
      ],
      demo: _TodosDemo(todosAsync: todosAsync),
      snippets: const [
        CodeSnippet(title: 'async_notifier_providers.dart', code: _code),
      ],
    );
  }
}

class _TodosDemo extends ConsumerStatefulWidget {
  const _TodosDemo({required this.todosAsync});
  final AsyncValue<List<Todo>> todosAsync;

  @override
  ConsumerState<_TodosDemo> createState() => _TodosDemoState();
}

class _TodosDemoState extends ConsumerState<_TodosDemo> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(todosControllerProvider.notifier).add(text); // 비동기 추가
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '새 할 일(서버에 추가 흉내)',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    onSubmitted: (_) => _add(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _add, child: const Text('추가')),
                const SizedBox(width: 4),
                IconButton(
                  tooltip: '새로고침',
                  onPressed: () =>
                      ref.read(todosControllerProvider.notifier).refresh(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                // guard 가 예외를 AsyncError 로 잡는 것을 눈으로 확인
                onPressed: () => ref
                    .read(todosControllerProvider.notifier)
                    .simulateError(),
                icon: const Icon(Icons.bug_report, size: 18),
                label: const Text('AsyncValue.guard 에러 시뮬레이션'),
              ),
            ),
            const SizedBox(height: 8),
            AsyncValueView<List<Todo>>(
              value: widget.todosAsync,
              onRetry: () =>
                  ref.read(todosControllerProvider.notifier).refresh(),
              data: (todos) => Column(
                children: [
                  for (final todo in todos)
                    CheckboxListTile(
                      dense: true,
                      value: todo.completed,
                      title: Text(todo.todo,
                          style: TextStyle(
                            decoration: todo.completed
                                ? TextDecoration.lineThrough
                                : null,
                          )),
                      // 낙관적 토글
                      onChanged: (_) => ref
                          .read(todosControllerProvider.notifier)
                          .toggle(todo.id),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _code = r'''
@riverpod
class TodosController extends _$TodosController {
  @override
  Future<List<Todo>> build() async {
    final client = ref.watch(dummyJsonClientProvider);
    return client.fetchTodos(limit: 10); // 비동기 초기 로딩
  }

  void toggle(int id) {
    final current = state.value ?? const [];
    state = AsyncData([ /* id 항목만 완료 토글 */ ]); // 낙관적 업데이트
  }

  Future<void> add(String title) async {
    final current = state.value ?? const <Todo>[];
    // AsyncValue.guard: 콜백이 성공하면 AsyncData, 던지면 AsyncError 로 자동 변환
    state = await AsyncValue.guard(() async {
      final created = await ref.read(dummyJsonClientProvider).addTodo(todo: title);
      return [created, ...current];
    });
  }

  // try/catch 없이 에러를 AsyncError 로 잡는 예
  Future<void> simulateError() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      throw Exception('의도적 에러');  // guard 가 AsyncError 로 변환 → UI 에러 표시
    });
  }
}
''';
