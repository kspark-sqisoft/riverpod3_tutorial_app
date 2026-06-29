import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'keepalive_providers.dart';

/// 토픽 9: autoDispose & keepAlive — provider 의 폐기/유지.
class KeepAlivePage extends ConsumerStatefulWidget {
  const KeepAlivePage({super.key});

  @override
  ConsumerState<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends ConsumerState<KeepAlivePage> {
  bool _show = true; // 구독 위젯을 보였다/숨겼다 → 구독 생성/해제

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '9. autoDispose & keepAlive',
      explanation:
          'provider 는 게으르게(lazy) 동작합니다. 아무도 안 보면 아예 만들어지지 않다가, '
          '처음 watch 또는 listen 되는 순간 build() 가 실행되어 생성됩니다. '
          '코드생성 provider 는 기본이 autoDispose 라서, 마지막 구독자까지 사라지면(구독 0) '
          '폐기되고, 다음에 다시 구독하면 build 가 처음부터 재실행됩니다. '
          '(ref.read 는 1회성 읽기라 구독을 만들지 않습니다 — read 만 해서는 살아남지 못합니다.) '
          '@Riverpod(keepAlive: true) 를 붙이면 구독자가 0 이 되어도 폐기되지 않고 상태가 유지됩니다. '
          '각 provider 는 (카운터 + 생성 시각) 을 상태로 가집니다. "+1" 로 카운터를 올린 뒤, 아래 스위치를 '
          'OFF→ON 해서 구독을 끊었다 다시 이어보세요. autoDispose 는 폐기·재생성되어 카운터가 0 으로 돌아가고 '
          '생성 시각도 갱신되지만, keepAlive 는 카운터와 생성 시각이 그대로 유지됩니다(로그로도 확인).',
      points: const [
        '생성 시점: 처음 watch/listen 되는 순간 build() 실행 (lazy — 아무도 안 보면 안 만들어짐)',
        'autoDispose(기본): 구독자 0 → 폐기, 재구독 시 새로 build (카운터 0·시각 갱신)',
        'keepAlive: 구독자 0 이어도 상태 유지 (카운터·시각 그대로)',
        'ref.read 는 구독을 만들지 않음 → read 만으로는 provider 를 살려둘 수 없다',
        '실험: 두 카운터를 올린다 → 스위치 OFF → 다시 ON',
        '결과: autoDispose=0 으로 리셋, keepAlive=올린 값 유지',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('구독 위젯 표시(ON) / 숨김(OFF)'),
                  subtitle: const Text('OFF 로 구독을 끊었다가 다시 ON 해서 차이를 보세요'),
                  value: _show,
                  onChanged: (v) => setState(() => _show = v),
                ),
                if (_show)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: _CounterWatchers(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 180),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'keepalive_providers.dart', code: _code),
      ],
    );
  }
}

/// 두 provider(카운터+생성시각)를 함께 구독해 보여주는 위젯.
/// 이 위젯이 사라지면(스위치 OFF) 구독이 해제된다 → autoDispose 는 폐기, keepAlive 는 유지.
class _CounterWatchers extends ConsumerWidget {
  const _CounterWatchers();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (autoCount, autoAt) = ref.watch(autoDisposeCounterProvider);
    final (keptCount, keptAt) = ref.watch(keepAliveCounterProvider);
    return Column(
      children: [
        _CounterRow(
          accent: Colors.deepOrange,
          label: 'autoDispose (기본)',
          createdAt: autoAt,
          count: autoCount,
          onInc: () =>
              ref.read(autoDisposeCounterProvider.notifier).increment(),
        ),
        const Divider(),
        _CounterRow(
          accent: Colors.green,
          label: 'keepAlive',
          createdAt: keptAt,
          count: keptCount,
          onInc: () => ref.read(keepAliveCounterProvider.notifier).increment(),
        ),
      ],
    );
  }
}

/// 한 provider 의 라벨 + 생성 시각 + 카운터 + '+1' 버튼.
class _CounterRow extends StatelessWidget {
  const _CounterRow({
    required this.accent,
    required this.label,
    required this.createdAt,
    required this.count,
    required this.onInc,
  });

  final Color accent;
  final String label;
  final String createdAt;
  final int count;
  final VoidCallback onInc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style:
                      TextStyle(color: accent, fontWeight: FontWeight.bold)),
              Text('생성 시각 $createdAt',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        Text('카운터 $count', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 8),
        FilledButton.tonal(onPressed: onInc, child: const Text('+1')),
      ],
    );
  }
}

const String _code = r'''
// 상태 = (카운터, 생성 시각)
typedef CounterState = (int count, String createdAt);

@riverpod                          // 기본 autoDispose
class AutoDisposeCounter extends _$AutoDisposeCounter {
  @override
  CounterState build() {
    ref.onDispose(() => /* 폐기 로그 */);
    return (0, nowHHmmss());        // 재구독 시 새로 build → 카운터 0, 시각 갱신
  }
  void increment() {
    final (c, at) = state;
    state = (c + 1, at);
  }
}

@Riverpod(keepAlive: true)         // 폐기되지 않음
class KeepAliveCounter extends _$KeepAliveCounter {
  @override
  CounterState build() => (0, nowHHmmss()); // 한 번 만들면 카운터/시각 유지
  void increment() { final (c, at) = state; state = (c + 1, at); }
}
''';
