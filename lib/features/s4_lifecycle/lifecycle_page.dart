import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'lifecycle_providers.dart';

/// 토픽 11: 프로바이더 라이프사이클 콜백.
///
/// 두 개의 구독 스위치로 onAddListener/onRemoveListener/onCancel/onResume 를,
/// '무효화' 버튼으로 onDispose 를 직접 관찰한다.
class LifecyclePage extends ConsumerStatefulWidget {
  const LifecyclePage({super.key});

  @override
  ConsumerState<LifecyclePage> createState() => _LifecyclePageState();
}

class _LifecyclePageState extends ConsumerState<LifecyclePage> {
  bool _subA = false; // 구독 A on/off
  bool _subB = false; // 구독 B on/off

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '11. 프로바이더 라이프사이클 콜백',
      explanation:
          '프로바이더는 Uninitialized → Alive → (Paused) → Disposed 의 생애를 가집니다. '
          'ref 에 등록한 콜백으로 각 전환을 관찰할 수 있습니다. 아래 두 스위치로 구독을 '
          '추가/제거하며 로그를 확인하세요. 첫 구독에서 build(Alive), 마지막 구독 해제에서 '
          'onCancel(Paused), 재구독에서 onResume 이 찍힙니다. (keepAlive 라 자동 폐기되지 '
          '않으므로 onDispose 는 "무효화" 버튼으로 직접 일으킵니다.)',
      points: const [
        'onAddListener / onRemoveListener: 구독이 늘고 줄 때',
        'onCancel: 마지막 구독이 사라짐(Paused) — keepAlive 면 폐기는 안 됨',
        'onResume: 다시 구독되어 살아남(Alive)',
        'onDispose: 완전히 폐기(Disposed)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('구독 A'),
                  value: _subA,
                  onChanged: (v) => setState(() => _subA = v),
                ),
                SwitchListTile(
                  title: const Text('구독 B'),
                  value: _subB,
                  onChanged: (v) => setState(() => _subB = v),
                ),
                // 구독이 켜진 만큼 watcher 위젯을 띄운다(각 watcher = 리스너 1개).
                if (_subA) const _Watcher(label: 'A'),
                if (_subB) const _Watcher(label: 'B'),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: OutlinedButton.icon(
                    // 무효화 → onDispose 유발(이후 구독자 있으면 즉시 재생성)
                    onPressed: () => ref.invalidate(lifecycleDemoProvider),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('무효화(invalidate) → onDispose'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 220),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'lifecycle_providers.dart', code: _code),
      ],
    );
  }
}

/// provider 를 watch 하는 작은 위젯 = 리스너 1개. 표시되면 구독, 사라지면 구독 해제.
class _Watcher extends ConsumerWidget {
  const _Watcher({required this.label});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(lifecycleDemoProvider);
    return ListTile(
      dense: true,
      leading: const Icon(Icons.visibility),
      title: Text('구독 $label 가 보는 값: $value'),
    );
  }
}

const String _code = r'''
@Riverpod(keepAlive: true)
String lifecycleDemo(Ref ref) {
  ref.onAddListener(()    => log('리스너 추가'));
  ref.onRemoveListener(() => log('리스너 제거'));
  ref.onCancel(()         => log('Paused: 마지막 리스너 사라짐'));
  ref.onResume(()         => log('Alive: 다시 구독'));
  ref.onDispose(()        => log('Disposed: 폐기'));
  return '생성됨';
}
''';
