import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'legacy_providers.dart';

/// 토픽 4: Legacy 비교 — StateProvider / StateNotifierProvider.
///
/// 왜 legacy 가 되었고 Notifier 로 어떻게 대체하는지 비교한다.
class LegacyPage extends ConsumerWidget {
  const LegacyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(legacyCounterProvider); // 레거시 StateProvider 구독

    return ConceptPage(
      title: '4. Legacy 비교 (StateProvider 등)',
      explanation:
          'Riverpod 2 시절 많이 쓰던 StateProvider/StateNotifierProvider 는 3.0에서 '
          'package:flutter_riverpod/legacy.dart 로 옮겨졌습니다(여전히 동작하지만 권장 X). '
          '이유는 외부에서 state 를 직접 바꾸는 구조가 캡슐화/테스트에 불리하기 때문입니다. '
          '대신 상태 변경 로직을 메서드로 캡슐화하는 NotifierProvider 로 대체합니다.',
      points: const [
        'StateProvider: ref.read(p.notifier).state++ 처럼 외부에서 state 직접 변경',
        'NotifierProvider: increment() 같은 메서드로 변경 로직을 안에 캡슐화',
        '신규 코드는 Notifier/AsyncNotifier 사용 (legacy 는 마이그레이션 비교용)',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('레거시 StateProvider 카운터',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('count = $count',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Spacer(),
                  // 레거시 방식: notifier.state 를 직접 증감
                  IconButton.filledTonal(
                    onPressed: () =>
                        ref.read(legacyCounterProvider.notifier).state--,
                    icon: const Icon(Icons.remove),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () =>
                        ref.read(legacyCounterProvider.notifier).state++,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'legacy (권장 X)', code: _legacyCode),
        CodeSnippet(title: '대체: Notifier (권장)', code: _modernCode),
      ],
    );
  }
}

const String _legacyCode = r'''
// import 'package:flutter_riverpod/legacy.dart';
final legacyCounterProvider = StateProvider<int>((ref) => 0);

// 사용처: 외부에서 state 를 직접 변경
ref.read(legacyCounterProvider.notifier).state++;
''';

const String _modernCode = r'''
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++; // 변경 로직을 메서드로 캡슐화
}

// 사용처
ref.read(counterProvider.notifier).increment();
''';
