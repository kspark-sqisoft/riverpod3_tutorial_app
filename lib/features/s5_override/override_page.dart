import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../s5_clean_arch/clean_arch_providers.dart';
import '../s5_clean_arch/domain/todo_entity.dart';
import '../s5_clean_arch/domain/todo_repository.dart';

/// 토픽 14의 배선을 그대로 재사용하되, todoRepository 만 가짜로 바꿔치기 한다.
class FakeTodoRepository implements TodoRepository {
  @override
  Future<List<TodoEntity>> getTodos() async => const [
        TodoEntity(id: 1, title: '가짜 데이터: 오프라인 모드', done: true),
        TodoEntity(id: 2, title: '가짜 데이터: 테스트용', done: false),
        TodoEntity(id: 3, title: '가짜 데이터: override 로 주입됨', done: false),
      ];
}

/// 토픽 15: override & 의존성 교체(DI 실전).
class OverridePage extends ConsumerWidget {
  const OverridePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConceptPage(
      title: '15. override & 의존성 교체',
      explanation:
          'ProviderScope(overrides: [...]) 로 특정 provider 를 다른 구현/값으로 "재바인딩"할 수 '
          '있습니다. 토픽 14의 클린 아키텍처 배선을 그대로 둔 채, todoRepositoryProvider 만 '
          'FakeTodoRepository 로 교체하면 아래 영역의 cleanTodos 가 가짜 데이터를 보여줍니다. '
          '추상 타입에 의존했기 때문에 구현 교체가 한 줄로 끝납니다(오프라인/데모/테스트에 유용).',
      points: const [
        'overrideWithValue / overrideWith: provider 를 재바인딩',
        '중첩 ProviderScope: 특정 서브트리에서만 override 적용',
        '추상에 의존 → 구현 교체가 쉬움(테스트 더블 주입)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('① 실제 구현(dummyjson)',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          const Card(child: Padding(padding: EdgeInsets.all(8), child: _Todos())),
          const SizedBox(height: 16),
          Text('② override 로 교체한 Fake (중첩 ProviderScope)',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          // 이 서브트리에서만 todoRepository 가 Fake 로 교체된다.
          ProviderScope(
            overrides: [
              todoRepositoryProvider.overrideWithValue(FakeTodoRepository()),
            ],
            child: Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: const Padding(padding: EdgeInsets.all(8), child: _Todos()),
            ),
          ),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'override 사용', code: _code),
      ],
    );
  }
}

/// 두 영역이 동일하게 cleanTodosProvider 를 watch — 어떤 repository 가 주입됐는지에 따라
/// 결과가 달라진다.
class _Todos extends ConsumerWidget {
  const _Todos();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosAsync = ref.watch(cleanTodosProvider);
    return AsyncValueView<List<TodoEntity>>(
      value: todosAsync,
      data: (todos) => Column(
        children: [
          for (final t in todos)
            ListTile(
              dense: true,
              leading: Icon(
                  t.done ? Icons.check_circle : Icons.radio_button_unchecked),
              title: Text(t.title),
            ),
        ],
      ),
    );
  }
}

const String _code = r'''
class FakeTodoRepository implements TodoRepository {
  @override
  Future<List<TodoEntity>> getTodos() async => [ /* 가짜 데이터 */ ];
}

// 이 서브트리에서만 구현을 교체
ProviderScope(
  overrides: [
    todoRepositoryProvider.overrideWithValue(FakeTodoRepository()),
  ],
  child: const _Todos(), // 같은 cleanTodos 를 watch 하지만 결과는 가짜
);
''';
