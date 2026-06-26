import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../shared/app_logger.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';

final _a = signal(0);
final _b = signal(0);

/// 토픽 32: batch & untracked — Riverpod 엔 직접 대응이 없는 signals 고유 기능.
class BatchUntrackedPage extends StatefulWidget {
  const BatchUntrackedPage({super.key});

  @override
  State<BatchUntrackedPage> createState() => _BatchUntrackedPageState();
}

class _BatchUntrackedPageState extends State<BatchUntrackedPage> {
  void Function()? _disposeEffect;

  @override
  void initState() {
    super.initState();
    // a 또는 b 가 바뀔 때마다 실행. batch 로 묶으면 여러 변경이 1회로 합쳐진다.
    _disposeEffect = effect(() {
      log.d('🪝 effect 실행: a=${_a.value}, b=${_b.value}');
    });
  }

  @override
  void dispose() {
    _disposeEffect?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '32. batch & untracked (signals 고유)',
      explanation:
          'batch(() {...}) 는 여러 signal 변경을 하나의 알림으로 합쳐, effect/Watch 가 한 번만 '
          '재실행되게 합니다. untracked(() => ...) 는 signal 을 읽되 의존성으로 추적하지 않습니다. '
          'Riverpod 에는 이 둘에 직접 대응하는 API 가 없습니다(상태 모델이 다름). 아래 두 버튼으로 '
          '효과를 비교하세요 — 로그가 2번 vs 1번 찍힙니다.',
      points: const [
        'batch: 여러 변경을 1회 알림으로 묶음(불필요한 중간 재계산 방지)',
        'untracked: signal 을 읽되 의존성에서 제외',
        'Riverpod 엔 직접 대응 API 없음(보너스 비교 포인트)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SignalBuilder(builder:(context) => Text('a=${_a.value} · b=${_b.value}',
                      style: Theme.of(context).textTheme.titleLarge)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      OutlinedButton(
                        // 개별 변경 → effect 2회 실행
                        onPressed: () {
                          _a.value++;
                          _b.value++;
                        },
                        child: const Text('개별 업데이트 (effect 2회)'),
                      ),
                      FilledButton(
                        // batch 로 묶음 → effect 1회 실행
                        onPressed: () => batch(() {
                          _a.value++;
                          _b.value++;
                        }),
                        child: const Text('batch 업데이트 (effect 1회)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 180),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'signals', code: _signalsCode),
      ],
    );
  }
}

const String _signalsCode = r'''
final a = signal(0);
final b = signal(0);
effect(() => log('a=${a.value}, b=${b.value}'));

a.value++; b.value++;          // effect 2번 실행

batch(() {                     // effect 1번만 실행
  a.value++;
  b.value++;
});

// untracked: 읽되 추적 안 함 → a 만 의존, b 변경엔 무반응
final c = computed(() => a.value + untracked(() => b.value));
''';
