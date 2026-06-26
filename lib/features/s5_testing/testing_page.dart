import 'package:flutter/material.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';

/// 토픽 20: 테스트 — ProviderContainer.test() 와 override.
///
/// 실제 테스트는 test/providers_test.dart 에 작성되어 있으며 `flutter test` 로 실행한다.
class TestingPage extends StatelessWidget {
  const TestingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '20. 테스트',
      explanation:
          'Riverpod 은 테스트가 쉽습니다. ProviderContainer.test() 로 격리된 컨테이너를 만들고, '
          'overrides 로 의존성을 가짜로 주입한 뒤, container.read 로 상태를 검증합니다. '
          '비동기 provider 는 container.read(provider.future) 로 결과를 기다립니다. '
          '이 토픽의 코드는 실제로 test/providers_test.dart 에 있으며 flutter test 로 통과합니다.',
      points: const [
        'ProviderContainer.test(): 테스트 끝에 자동 dispose',
        'overrides: 가짜 repository/값 주입(토픽 14·15 재사용)',
        'container.read(p): 동기 상태 검증',
        'await container.read(p.future): 비동기 provider 결과 검증',
      ],
      demo: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: const [
              Icon(Icons.verified),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  '터미널에서 `flutter test` 실행 → 아래 테스트들이 통과합니다.',
                ),
              ),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'test/providers_test.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
test('TodoList: add 하면 항목이 늘어난다', () {
  final container = ProviderContainer.test();
  expect(container.read(todoListProvider).length, 2);
  container.read(todoListProvider.notifier).add('새 할일');
  expect(container.read(todoListProvider).length, 3);
});

test('cleanTodos: repository override 로 가짜 데이터 주입', () async {
  final container = ProviderContainer.test(
    overrides: [todoRepositoryProvider.overrideWithValue(FakeRepo())],
  );
  final todos = await container.read(cleanTodosProvider.future);
  expect(todos.single.title, 'fake');
});
''';
