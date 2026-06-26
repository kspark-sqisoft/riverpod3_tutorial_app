import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';
import 'keepalive_pages_providers.dart';

/// 토픽 38: keepAlive vs autoDispose 체감 (여러 페이지에 걸쳐).
class KeepAlivePagesPage extends ConsumerWidget {
  const KeepAlivePagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volatile = ref.watch(volatileCounterProvider); // autoDispose
    final persistent = ref.watch(persistentCounterProvider); // keepAlive

    return ConceptPage(
      title: '38. keepAlive vs autoDispose 체감 (여러 페이지)',
      explanation:
          '두 카운터를 모두 올린 뒤, 왼쪽 목차에서 다른 토픽을 눌렀다가 다시 이 토픽으로 돌아오세요. '
          'autoDispose 카운터는 화면을 떠나는 순간 폐기되어 0으로 초기화되고(로그에 dispose), '
          'keepAlive 카운터는 값이 그대로 유지됩니다. 게다가 keepAlive 값은 홈(랜딩) 페이지에서도 '
          '동일하게 보입니다 — "페이지를 건너서도 살아있는" 것을 직접 느껴 보세요.',
      points: const [
        'autoDispose(기본): 구독 화면을 떠나면 폐기 → 다시 오면 0부터',
        'keepAlive: 구독자가 없어도 유지 → 페이지를 옮겨도 값 보존',
        '홈(랜딩) 페이지에도 keepAlive 카운터가 표시됨(같은 값)',
        '로그에서 autoDispose 의 dispose 시점을 확인',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CounterCard(
            color: Theme.of(context).colorScheme.errorContainer,
            label: 'autoDispose 카운터 (떠나면 0으로 초기화)',
            value: volatile,
            onInc: () => ref.read(volatileCounterProvider.notifier).increment(),
          ),
          const SizedBox(height: 8),
          _CounterCard(
            color: Theme.of(context).colorScheme.primaryContainer,
            label: 'keepAlive 카운터 (페이지 옮겨도 유지)',
            value: persistent,
            onInc: () =>
                ref.read(persistentCounterProvider.notifier).increment(),
          ),
          const SizedBox(height: 8),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                '실험: ① 두 값을 올린다 → ② 왼쪽에서 다른 토픽 클릭 → ③ 다시 이 토픽으로\n'
                '결과: autoDispose=0, keepAlive=그대로. (홈 페이지에서도 keepAlive 값 확인 가능)',
              ),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 180),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'keepalive_pages_providers.dart', code: _code),
      ],
    );
  }
}

class _CounterCard extends StatelessWidget {
  const _CounterCard({
    required this.color,
    required this.label,
    required this.value,
    required this.onInc,
  });

  final Color color;
  final String label;
  final int value;
  final VoidCallback onInc;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Text('$value', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 12),
            FilledButton(onPressed: onInc, child: const Text('+1')),
          ],
        ),
      ),
    );
  }
}

const String _code = r'''
@riverpod                       // 기본 autoDispose
class VolatileCounter extends _$VolatileCounter {
  @override int build() => 0;   // 화면 떠나면 폐기 → 다시 오면 0
  void increment() => state++;
}

@Riverpod(keepAlive: true)      // 유지
class PersistentCounter extends _$PersistentCounter {
  @override int build() => 0;   // 구독자 없어도 유지 → 페이지 옮겨도 값 보존
  void increment() => state++;
}
''';
