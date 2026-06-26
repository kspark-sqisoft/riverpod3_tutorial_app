import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/async_value_view.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../clean_arch_providers.dart';
import '../domain/todo_entity.dart';

/// 토픽 14: Riverpod = DI 컨테이너 & 간단한 클린 아키텍처.
class CleanArchPage extends ConsumerWidget {
  const CleanArchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(cleanTodosProvider);

    return ConceptPage(
      title: '14. DI 컨테이너 & 간단한 클린 아키텍처',
      explanation:
          'Riverpod 의 ProviderScope 는 곧 DI 컨테이너입니다. 각 provider 가 의존성 "등록", '
          'ref.watch/read 가 "주입(resolve)", override 가 "재바인딩"입니다. 아래는 Todos 를 '
          '3계층(presentation → domain → data)으로 나눈 예입니다. 도메인은 추상 '
          'TodoRepository 만 알고, 실제 HTTP 구현은 data 레이어에 있으며, 그 연결(배선)은 '
          'todoRepositoryProvider 한 곳에서만 일어납니다(의존성 역전).',
      points: const [
        'presentation: cleanTodosProvider(컨트롤러) → UI',
        'domain: TodoEntity, 추상 TodoRepository (Flutter/HTTP 모름)',
        'data: TodoRepositoryImpl(DummyJsonClient) — DTO→엔티티 매핑',
        'DI 배선: dummyJsonClient → todoRepository(추상) → cleanTodos → UI',
        'override 로 todoRepository 만 바꾸면 구현 전체 교체(토픽 15)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 의존성 그래프 도식
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'dummyJsonClientProvider\n'
                '        ↓ (주입)\n'
                'todoRepositoryProvider  «추상 TodoRepository»\n'
                '        ↓\n'
                'cleanTodosProvider  (컨트롤러)\n'
                '        ↓\n'
                'UI (이 화면)',
                style: TextStyle(fontFamily: 'monospace', height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: AsyncValueView<List<TodoEntity>>(
                value: todosAsync,
                onRetry: () => ref.invalidate(cleanTodosProvider),
                data: (todos) => Column(
                  children: [
                    for (final t in todos)
                      ListTile(
                        dense: true,
                        leading: Icon(t.done
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked),
                        title: Text(t.title),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'clean_arch_providers.dart (DI 배선)', code: _code),
      ],
    );
  }
}

const String _code = r'''
// domain (추상) — 구현을 모름
abstract interface class TodoRepository {
  Future<List<TodoEntity>> getTodos();
}

// data (구현) — DTO를 도메인 엔티티로 매핑
class TodoRepositoryImpl implements TodoRepository { ... }

// DI 배선: 추상 ↔ 구현 연결은 여기 한 곳
@riverpod
TodoRepository todoRepository(Ref ref) =>
    TodoRepositoryImpl(ref.watch(dummyJsonClientProvider));

@riverpod
Future<List<TodoEntity>> cleanTodos(Ref ref) =>
    ref.watch(todoRepositoryProvider).getTodos(); // 추상에만 의존
''';
