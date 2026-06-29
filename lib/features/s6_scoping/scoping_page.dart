import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'scoping_providers.dart';

// 스코프마다 주입할 (라벨 + 색) 목록. 같은 _ItemCard 가 스코프에 따라 다르게 보인다.
const List<ScopedItem> _items = [
  ScopedItem('빨강 아이템', Colors.red),
  ScopedItem('초록 아이템', Colors.green),
  ScopedItem('파랑 아이템', Colors.blue),
];

/// 토픽 23: Provider 스코핑 — 중첩 ProviderScope 로 서브트리별 값 주입.
class ScopingPage extends StatelessWidget {
  const ScopingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '23. Provider 스코핑',
      explanation:
          'provider 는 보통 앱 전체에서 값이 "하나"입니다. 스코핑은 위젯 트리의 한 가지(서브트리)에서만 '
          '그 값을 다르게 쓰도록 덮어쓰는 기법입니다. 아래 세 카드는 완전히 똑같은 _ItemCard 코드'
          '(모두 같은 currentItemProvider 를 watch)인데, 각 카드를 감싼 중첩 ProviderScope 가 서로 다른 '
          'ScopedItem(라벨 + 색)을 overrideWithValue 로 주입했습니다. 그래서 같은 위젯이 빨강·초록·파랑으로 '
          '서로 다르게 보입니다 — "같은 provider, 다른 스코프 → 다른 값". 즉 위젯마다 생성자로 데이터를 일일이 '
          '넘기지 않고도 "이 서브트리에서는 이 값" 을 provider 로 흘려보낼 수 있습니다(리스트 행마다 그 행의 '
          '데이터를 자식들에게 전달하는 패턴). 참고: 색이 다른 것은 버그가 아니라 스코프가 주입한 값(color)이 '
          '카드마다 다르기 때문입니다.',
      points: const [
        '중첩 ProviderScope(overrides:)로 서브트리 한정 주입',
        '같은 provider · 같은 위젯, 다른 스코프 → 다른 값(라벨/색)',
        '주입값 차이가 화면 차이 — 색이 다른 건 정상(버그 아님)',
        '코드생성 스코프 의존성은 @Riverpod(dependencies: [...]) 로 명시',
        'Provider 로 위젯 트리에 데이터를 흘려보내는 의존성 주입 패턴',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final item in _items)
            // 각 카드를 별도 스코프로 감싸 currentItem 을 다르게(라벨+색) 주입
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
    final item = ref.watch(currentItemProvider); // 스코프가 주입한 값(라벨+색)
    return Card(
      color: item.color.withValues(alpha: 0.12), // 주입된 색으로 카드 배경
      child: ListTile(
        leading: Icon(Icons.label, color: item.color),
        title: Text(
          item.label,
          style: TextStyle(color: item.color, fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('같은 provider · 같은 위젯, 다른 스코프 → 다른 값'),
      ),
    );
  }
}

const String _code = r'''
// 스코프가 주입할 값(라벨 + 색)
class ScopedItem {
  const ScopedItem(this.label, this.color);
  final String label;
  final Color color;
}

@riverpod
ScopedItem currentItem(Ref ref) =>
    throw UnimplementedError('scope override 필요');

// 아이템마다 별도 스코프로 서로 다른 값 주입
for (final item in items)
  ProviderScope(
    overrides: [currentItemProvider.overrideWithValue(item)],
    child: const _ItemCard(), // 내부에서 ref.watch(currentItemProvider)
  );

// _ItemCard 는 셋 다 같은 코드지만 스코프가 다르면 다른 값/색이 나온다
final item = ref.watch(currentItemProvider);
Text(item.label, style: TextStyle(color: item.color));
''';
