import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_logger.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import '../s0_basics/intro_providers.dart'; // introCounterProvider 재사용

/// 토픽 24: 운영(Operations) 패턴 — 실무에서 쓰는 관찰/초기화/구독 기법.
class OpsPage extends ConsumerWidget {
  const OpsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConceptPage(
      title: '24. 운영(Operations) 패턴',
      explanation:
          '실무에서 자주 쓰는 운영 기법들입니다. 이 앱은 이미 전역 ProviderObserver 로 모든 '
          'provider 이벤트를 로그로 남기고 있습니다(아래 실시간 로그). 그 밖에 앱 시작 시 핵심 '
          'provider 를 미리 데우는 eager initialization, 위젯 밖에서 구독하는 listenManual, '
          'providerDidFail 을 이용한 전역 에러 리포팅 등이 있습니다.',
      points: const [
        'ProviderObserver: 로깅/분석/Crashlytics 연동(이 앱에 전역 적용됨)',
        'providerDidFail: 전역 에러 리포팅 지점',
        'eager init: 앱 시작 시 ref.read 로 핵심 provider 워밍업',
        'listenManual: build 밖(콜백/initState)에서 구독 → 직접 close',
        'WidgetRef(위젯) vs Ref(provider 내부), ref.read 남용 주의',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _ManualListenDemo(),
          SizedBox(height: 12),
          LifecycleLogView(height: 200),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'listenManual / eager init', code: _code),
      ],
    );
  }
}

/// listenManual 데모: 버튼으로 수동 구독을 켜고 끄며, 카운터 변화 로그를 남긴다.
class _ManualListenDemo extends ConsumerStatefulWidget {
  const _ManualListenDemo();

  @override
  ConsumerState<_ManualListenDemo> createState() => _ManualListenDemoState();
}

class _ManualListenDemoState extends ConsumerState<_ManualListenDemo> {
  ProviderSubscription<int>? _sub; // 수동 구독 핸들

  @override
  void dispose() {
    _sub?.close(); // 위젯 폐기 시 수동 구독도 정리(필수)
    super.dispose();
  }

  void _toggle() {
    if (_sub == null) {
      // listenManual: build 밖에서 구독. 반환된 구독은 직접 close 해야 한다.
      _sub = ref.listenManual(introCounterProvider, (previous, next) {
        log.i('🛰️ listenManual: $previous → $next');
      });
    } else {
      _sub!.close();
      _sub = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final on = _sub != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('수동 구독 상태: ${on ? '켜짐' : '꺼짐'}'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _toggle,
                  child: Text(on ? '수동 구독 해제' : '수동 구독 시작'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  // introCounter 를 증가 → 수동 구독이 켜져 있으면 로그가 찍힘
                  onPressed: () =>
                      ref.read(introCounterProvider.notifier).increment(),
                  child: const Text('카운터 +1'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

const String _code = r'''
// 위젯 밖에서 구독(콜백/initState 등) — 직접 close 책임
final sub = ref.listenManual(introCounterProvider, (prev, next) {
  log('$prev → $next');
});
// ... 나중에
sub.close();

// eager initialization: 앱 시작 시 핵심 provider 워밍업
void main() {
  final container = ProviderContainer();
  container.read(criticalProvider); // 미리 생성
  runApp(UncontrolledProviderScope(container: container, child: ...));
}
''';
