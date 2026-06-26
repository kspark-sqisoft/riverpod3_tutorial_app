import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart'; // 실험적 Mutations API
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/api_providers.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';

/// 전역 Mutation 정의(코드생성 없이 간단한 형태).
/// 제네릭은 작업 결과 타입(여기선 결과를 안 쓰므로 void).
final addTodoMutation = Mutation<void>();

/// 토픽 17: Mutations(실험적) — 폼 제출 같은 사이드이펙트의 진행 상태 추적.
class MutationsPage extends ConsumerStatefulWidget {
  const MutationsPage({super.key});

  @override
  ConsumerState<MutationsPage> createState() => _MutationsPageState();
}

class _MutationsPageState extends ConsumerState<MutationsPage> {
  final _controller = TextEditingController(text: '새로운 할 일');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final client = ref.read(dummyJsonClientProvider); // await 전에 미리 읽기
    // run: 콜백을 실행하며 mutation 상태를 Pending → Success/Error 로 전환한다.
    // 콜백은 MutationTransaction 을 받지만 여기선 쓰지 않으므로 _ 로 둔다.
    addTodoMutation.run(ref, (_) async {
      await client.addTodo(todo: _controller.text.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    // mutation 상태를 구독 → 상태에 따라 버튼/스피너/결과를 그린다.
    final state = ref.watch(addTodoMutation);

    return ConceptPage(
      title: '17. Mutations (실험적)',
      explanation:
          'Mutation 은 폼 제출 같은 "사이드이펙트"의 loading/success/error 를 provider 상태와 '
          '분리해 추적하는 실험적 기능입니다. UI 는 MutationIdle/Pending/Success/Error 를 '
          'switch 로 분기하고, 버튼 콜백에서 mutation.run(ref, () async {...}) 로 실행합니다. '
          '제출 중에는 자동으로 Pending, 끝나면 Success/Error 로 바뀝니다.',
      points: const [
        'Mutation<T>(): 전역으로 정의(또는 코드생성 @mutation)',
        'ref.watch(mutation): MutationState 구독',
        'mutation.run(ref, cb): Pending → Success/Error 자동 전환',
        '구독이 사라지면 자동으로 Idle 로 리셋(auto-dispose 와 유사)',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: '추가할 할 일',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // 상태별 UI 분기 — sealed 타입이라 모든 경우를 강제 처리
              switch (state) {
                MutationIdle() => FilledButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.send),
                    label: const Text('제출'),
                  ),
                MutationPending() => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 12),
                          Text('제출 중...'),
                        ],
                      ),
                    ),
                  ),
                MutationError(:final error) => Column(
                    children: [
                      Text('❌ 실패: $error',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                      const SizedBox(height: 8),
                      OutlinedButton(
                          onPressed: _submit, child: const Text('다시 시도')),
                    ],
                  ),
                MutationSuccess() => Column(
                    children: [
                      const Text('✅ 추가 완료!'),
                      const SizedBox(height: 8),
                      OutlinedButton(
                          onPressed: _submit, child: const Text('다시 제출')),
                    ],
                  ),
              },
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'mutations_page.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
final addTodoMutation = Mutation<void>();

// 위젯
final state = ref.watch(addTodoMutation);
switch (state) {
  MutationIdle()    => 버튼(onPressed: submit),
  MutationPending() => 스피너,
  MutationError(:final error) => Text('실패: $error'),
  MutationSuccess() => Text('완료!'),
};

void submit() => addTodoMutation.run(ref, (_) async {
  await client.addTodo(todo: title);  // 상태가 Pending→Success/Error 로 자동 전환
});
''';
