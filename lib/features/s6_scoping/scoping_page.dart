import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'scoping_providers.dart';

const List<String> _items = ['빨강 아이템', '초록 아이템', '파랑 아이템'];

/// 토픽 23: Provider 스코핑 — 중첩 ProviderScope 로 서브트리별 값 주입.
class ScopingPage extends StatelessWidget {
  const ScopingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '23. Provider 스코핑',
      explanation:
          '같은 provider 라도 중첩 ProviderScope 의 overrides 로 "서브트리마다 다른 값"을 줄 수 '
          '있습니다. 아래 세 카드는 모두 동일한 currentItemProvider 를 watch 하지만, 각 카드를 '
          '감싼 ProviderScope 가 서로 다른 값을 주입했기 때문에 서로 다른 내용을 표시합니다. '
          '리스트 아이템마다 해당 데이터를 자식 위젯들에게 흘려보낼 때 유용한 패턴입니다.',
      points: const [
        '중첩 ProviderScope(overrides:)로 서브트리 한정 주입',
        '같은 provider, 다른 스코프 → 다른 값',
        '코드생성 스코프 의존성은 @Riverpod(dependencies: [...]) 로 명시',
        'Provider 로 위젯 트리에 데이터를 흘려보내는 의존성 주입 패턴',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in _items)
            // 각 카드를 별도 스코프로 감싸 currentItem 을 다르게 주입
            ProviderScope(
              overrides: [currentItemProvider.overrideWithValue(item)],
              child: const _ItemCard(),
            ),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'scoping 사용', code: _code),
      ],
    );
  }
}

/// 동일한 currentItemProvider 를 읽는 자식 — 어느 스코프 안에 있느냐에 따라 값이 달라진다.
class _ItemCard extends ConsumerWidget {
  const _ItemCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(currentItemProvider); // 스코프가 주입한 값
    return Card(
      child: ListTile(
        leading: const Icon(Icons.label),
        title: Text(item),
        subtitle: const Text('같은 provider, 다른 스코프'),
      ),
    );
  }
}

const String _code = r'''
@riverpod
String currentItem(Ref ref) =>
    throw UnimplementedError('scope override 필요');

// 아이템마다 별도 스코프로 값 주입
for (final item in items)
  ProviderScope(
    overrides: [currentItemProvider.overrideWithValue(item)],
    child: const _ItemCard(), // 내부에서 ref.watch(currentItemProvider)
  );
''';
