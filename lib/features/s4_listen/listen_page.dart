import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'listen_providers.dart';

/// 토픽 13: ref.listen & 사이드이펙트.
class ListenPage extends ConsumerWidget {
  const ListenPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.listen: 빌드 중에 등록하지만 UI 를 그리지 않고, 값이 바뀔 때
    // "동작"(스낵바/다이얼로그/네비게이션 등)을 실행한다.
    ref.listen(eventCounterProvider, (previous, next) {
      if (next != 0 && next % 5 == 0) {
        // 5의 배수가 되면 스낵바 — 전형적인 사이드이펙트
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('🎉 $next 도달! (ref.listen 사이드이펙트)')),
        );
      }
    });

    final count = ref.watch(eventCounterProvider);

    return ConceptPage(
      title: '13. ref.listen & 사이드이펙트',
      explanation:
          'ref.watch 가 "값을 UI 에 반영"하는 것이라면, ref.listen 은 값 변화에 반응해 '
          '스낵바·다이얼로그·페이지 이동 같은 "일회성 동작"을 실행할 때 씁니다. UI 빌드와 '
          '부수효과를 분리하는 것이 핵심입니다. provider 내부에서 자기 변화를 감지할 땐 '
          'listenSelf 를 사용합니다(아래 로그의 listenSelf 항목).',
      points: const [
        'ref.listen(provider, (prev, next) { ... }): 값 변화 → 사이드이펙트',
        'build 안에서 등록하지만 위젯을 그리지는 않는다',
        '카운터가 5의 배수가 될 때마다 스낵바가 뜬다',
        'listenSelf: provider 내부에서 자기 상태 변화 감지',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Text('count = $count',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () =>
                        ref.read(eventCounterProvider.notifier).reset(),
                    child: const Text('리셋'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () =>
                        ref.read(eventCounterProvider.notifier).increment(),
                    icon: const Icon(Icons.add),
                    label: const Text('증가(5의 배수에서 스낵바)'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 160),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'listen 사용', code: _code),
      ],
    );
  }
}

const String _code = r'''
// 위젯에서: 값 변화에 사이드이펙트
ref.listen(eventCounterProvider, (prev, next) {
  if (next % 5 == 0) {
    ScaffoldMessenger.of(context).showSnackBar(...);
  }
});

// provider 내부에서: 자기 상태 변화 감지
@riverpod
class EventCounter extends _$EventCounter {
  @override
  int build() {
    listenSelf((prev, next) => log('$prev → $next'));
    return 0;
  }
}
''';
