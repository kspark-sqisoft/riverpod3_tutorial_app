import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../shared/app_logger.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';

/// 토픽 31: autoDispose & 라이프사이클. (Riverpod autoDispose/lifecycle 토픽 9·11 대응)
class SignalsLifecyclePage extends StatefulWidget {
  const SignalsLifecyclePage({super.key});

  @override
  State<SignalsLifecyclePage> createState() => _SignalsLifecyclePageState();
}

class _SignalsLifecyclePageState extends State<SignalsLifecyclePage> {
  bool _show = true; // 자식 위젯 표시/숨김 → 생성/폐기

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '31. autoDispose & 라이프사이클',
      explanation:
          '전역 signal 은 앱 내내 살아있지만, 위젯 안에서 만든 "지역 signal"은 위젯이 사라질 때 '
          '직접 dispose 해야 합니다(아래 데모는 State.dispose 에서 정리). effect 도 반환된 정리 '
          '함수로 해제합니다. 아래 스위치로 위젯을 껐다 켜며 생성/폐기 로그를 확인하세요. signals 에는 '
          'Riverpod 의 autoDispose(구독 0 시 자동 폐기)나 onAddListener/onCancel/onResume, '
          'ProviderObserver 같은 세밀한 라이프사이클/전역 관찰은 없습니다(차이 → 토픽 33).',
      points: const [
        '전역 signal: 앱 내내 유지 / 지역 signal: 직접 dispose 필요',
        'effect: 반환된 정리 함수로 해제(위젯 dispose 에서)',
        'signal(autoDispose: true) 옵션으로 구독 0 시 자동 폐기도 가능',
        'onCancel/onResume/Observer 같은 세밀한 라이프사이클은 없음',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('signals 위젯 표시(ON) / 숨김(OFF)'),
                  value: _show,
                  onChanged: (v) => setState(() => _show = v),
                ),
                if (_show) const Padding(
                  padding: EdgeInsets.all(16),
                  child: _AutoDisposeDemo(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 200),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'signals', code: _signalsCode),
        CodeSnippet(title: 'Riverpod (대응)', code: _riverpodCode),
      ],
    );
  }
}

/// 지역 signal 은 전역과 달리 위젯이 사라질 때 직접 dispose 해야 한다.
class _AutoDisposeDemo extends StatefulWidget {
  const _AutoDisposeDemo();

  @override
  State<_AutoDisposeDemo> createState() => _AutoDisposeDemoState();
}

class _AutoDisposeDemoState extends State<_AutoDisposeDemo> {
  // 지역 signal/computed — 위젯 폐기 시 직접 정리한다(아래 dispose).
  final _counter = signal(0);
  late final _doubled = computed(() => _counter.value * 2);
  void Function()? _disposeEffect;

  @override
  void initState() {
    super.initState();
    log.i('🟢 signals 위젯 생성 (지역 signal/computed)');
    _disposeEffect = effect(() {
      log.t('🪝 effect: counter=${_counter.value}, doubled=${_doubled.value}');
    });
  }

  @override
  void dispose() {
    _disposeEffect?.call(); // effect 정리
    _counter.dispose(); // 지역 signal 직접 정리
    _doubled.dispose();
    log.i('⚪ signals 위젯 폐기 → 지역 signal 직접 dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SignalBuilder(builder: (context) => Text('counter=${_counter.value} · doubled=${_doubled.value}')),
        const Spacer(),
        FilledButton(
          onPressed: () => _counter.value++,
          child: const Text('증가'),
        ),
      ],
    );
  }
}

const String _signalsCode = r'''
class _State extends State<W> {
  final counter = signal(0);                     // 지역 signal
  late final doubled = computed(() => counter.value * 2);
  void Function()? _eff;

  @override void initState() {
    super.initState();
    _eff = effect(() => log('counter=${counter.value}'));
  }
  @override void dispose() {
    _eff?.call();                                 // effect 해제
    counter.dispose();                            // 지역 signal 직접 정리
    doubled.dispose();
    super.dispose();
  }
}
// 또는 signal(0, autoDispose: true) 로 구독 0 시 자동 폐기
''';

const String _riverpodCode = r'''
@riverpod                       // 기본 autoDispose
String demo(Ref ref) {
  ref.onDispose(() => log('폐기'));
  ref.onCancel(() => log('구독 0'));   // signals 엔 대응 없음
  ref.onResume(() => log('재구독'));   // signals 엔 대응 없음
  return '...';
}
''';
