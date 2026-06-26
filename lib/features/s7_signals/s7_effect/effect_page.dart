import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../shared/app_logger.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';

final _counter = signal(0);

/// 토픽 27: effect — signal 변화에 반응하는 사이드이펙트. (Riverpod ref.listen/listenSelf 대응)
class EffectPage extends StatefulWidget {
  const EffectPage({super.key});

  @override
  State<EffectPage> createState() => _EffectPageState();
}

class _EffectPageState extends State<EffectPage> {
  void Function()? _disposeEffect; // effect 정리 함수

  @override
  void initState() {
    super.initState();
    // effect: 콜백에서 읽은 signal 이 바뀔 때마다 실행(등록 즉시 1회도 실행).
    // 반환된 정리 함수를 호출하면 구독이 끊긴다.
    _disposeEffect = effect(() {
      final v = _counter.value; // 읽으면 추적됨
      log.d('🪝 effect 실행: counter = $v');
      if (v != 0 && v % 5 == 0) {
        log.i('🎉 effect: $v 도달! (5의 배수 사이드이펙트)');
      }
    });
  }

  @override
  void dispose() {
    _disposeEffect?.call(); // 위젯 폐기 시 effect 정리(필수)
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '27. effect (사이드이펙트)',
      explanation:
          'effect(() {...}) 는 콜백에서 읽은 signal 이 바뀔 때마다 부수효과를 실행합니다. '
          '등록 즉시 1회 실행되고, 이후 변경마다 재실행되며, 반환된 정리 함수로 해제합니다. '
          'Riverpod 의 ref.listen(위젯) / listenSelf(provider 내부)에 대응합니다. 아래 카운터를 '
          '올리면 effect 가 매번 로그를 남기고, 5의 배수에서 특별 로그를 남깁니다.',
      points: const [
        'effect: 읽은 signal 변경마다 실행(즉시 1회 포함)',
        '반환값(정리 함수) 호출로 구독 해제 — 위젯 dispose 에서 정리',
        'Riverpod ref.listen / listenSelf 에 대응',
        'UI 빌드와 부수효과를 분리(로그/분석/네트워크 트리거 등)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  SignalBuilder(builder:(context) => Text('count = ${_counter.value}',
                      style: Theme.of(context).textTheme.titleLarge)),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => _counter.value = 0,
                    child: const Text('리셋'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => _counter.value++,
                    icon: const Icon(Icons.add),
                    label: const Text('증가(5의 배수에서 특별 로그)'),
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
        CodeSnippet(title: 'Riverpod (대응)', code: _riverpodCode),
      ],
    );
  }
}

const String _signalsCode = r'''
final counter = signal(0);

final dispose = effect(() {           // 변경마다 실행(즉시 1회 포함)
  final v = counter.value;            // 읽으면 추적
  if (v % 5 == 0) log('5의 배수: $v');
});
// ... 나중에
dispose();                            // 구독 해제
''';

const String _riverpodCode = r'''
// 위젯에서
ref.listen(counterProvider, (prev, next) {
  if (next % 5 == 0) showSnackBar(...);
});
// provider 내부에서
listenSelf((prev, next) => log('$prev → $next'));
''';
