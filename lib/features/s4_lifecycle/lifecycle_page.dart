import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'lifecycle_providers.dart';

/// 토픽 11: 프로바이더 라이프사이클 콜백.
///
/// 두 개의 구독 스위치로 onAddListener/onRemoveListener/onCancel/onResume 를,
/// '상태 변경' 버튼으로 "상태가 바뀌어도 라이프사이클 콜백은 안 찍힌다"를,
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
          'ref 에 등록한 콜백으로 각 전환을 관찰할 수 있습니다. 두 스위치로 구독을 추가/제거하면 '
          '첫 구독에서 build(Alive), 마지막 구독 해제에서 onCancel(Paused), 재구독에서 onResume 이 찍힙니다. '
          '"상태 변경" 버튼은 Notifier 의 state 만 바꾸는데, 이때는 build 재실행도 onDispose 도 없이 '
          '리스너에게 "값이 바뀜" 알림만 갑니다("생성 @시각"은 그대로, "변경 N회"만 증가). '
          '"무효화" 버튼은 onDispose 후 build 를 다시 실행해 "생성 @시각"이 갱신되고 변경 횟수가 0 으로 리셋됩니다. '
          '(keepAlive 라 구독이 0 이어도 자동 폐기되지 않습니다.)',
      points: const [
        'onAddListener / onRemoveListener: 구독이 늘고 줄 때',
        'onCancel: 마지막 구독이 사라짐(Paused) — keepAlive 면 폐기는 안 됨',
        'onResume: 다시 구독되어 살아남(Alive)',
        '상태 변경(state=): 라이프사이클 콜백 없음 — build 재실행·onDispose 없이 리스너에 알림만',
        'invalidate: onDispose → build 재실행 (상태·생성시각 리셋)',
        '핵심 대비: "상태 변경"은 같은 인스턴스 유지 / "무효화"는 인스턴스 새로 build',
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
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          // 상태만 변경 → 라이프사이클 콜백 없이 리스너에 알림만
                          onPressed: () =>
                              ref.read(lifecycleDemoProvider.notifier).bump(),
                          icon: const Icon(Icons.add),
                          label: const Text('상태 변경(state++)'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          // 무효화 → onDispose 유발(이후 구독자 있으면 즉시 재생성)
                          onPressed: () => ref.invalidate(lifecycleDemoProvider),
                          icon: const Icon(Icons.delete_forever),
                          label: const Text('무효화 → onDispose'),
                        ),
                      ),
                    ],
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
class LifecycleDemo extends _$LifecycleDemo {
  String _createdAt = '';
  int _count = 0;

  @override
  String build() {
    _createdAt = nowHHmmss();
    _count = 0;
    ref.onAddListener(()    => log('리스너 추가'));
    ref.onRemoveListener(() => log('리스너 제거'));
    ref.onCancel(()         => log('Paused: 마지막 리스너 사라짐'));
    ref.onResume(()         => log('Alive: 다시 구독'));
    ref.onDispose(()        => log('Disposed: 폐기'));
    return '생성 @$_createdAt · 변경 0회';
  }

  // 상태만 변경 — build 재실행·onDispose 없이 리스너에 알림만 간다.
  void bump() {
    _count++;
    state = '생성 @$_createdAt · 변경 $_count회';
  }
}
''';
