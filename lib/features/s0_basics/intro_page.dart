import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_logger.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'intro_providers.dart';

/// 토픽 1: 소개 & ProviderScope.
///
/// ConsumerWidget 의 build 는 [WidgetRef] 를 받는다. 이 ref 로 provider 를
/// watch(구독) / read(1회 읽기) / listen(사이드이펙트) 할 수 있다.
class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // listen: 상태 변화에 "사이드이펙트"를 실행(빌드 중 호출, UI 를 그리지는 않음).
    ref.listen(introCounterProvider, (previous, next) {
      log.d('🔔 ref.listen 감지: counter $previous → $next');
    });

    // watch: 값 구독. greeting 이 바뀌면 이 위젯이 다시 그려진다(여기선 상수).
    final greeting = ref.watch(greetingProvider);

    return ConceptPage(
      title: '1. 소개 & ProviderScope',
      explanation:
          'Riverpod 은 상태를 위젯 트리 밖(ProviderScope)에 두고, 필요한 위젯이 ref 로 '
          '구독하는 상태관리 라이브러리입니다. 화면 위젯은 ConsumerWidget 으로 만들고, '
          'build(context, ref) 의 ref 를 통해 provider 에 접근합니다.',
      points: const [
        'ProviderScope: 앱 최상단(main)에서 provider 들의 루트 컨테이너 역할',
        'ref.watch: 값을 구독 → 값이 바뀌면 위젯 자동 rebuild (build 안에서 사용)',
        'ref.read: 지금 값을 1회만 읽음 → 버튼 콜백 등 일시적 동작에 사용',
        'ref.listen: 값 변화를 감지해 스낵바/네비게이션 같은 사이드이펙트 실행',
        'WidgetRef(위젯용) vs Ref(provider 내부용) 두 종류의 ref 가 있다',
      ],
      demo: _IntroDemo(greeting: greeting),
      snippets: const [
        CodeSnippet(title: 'intro_providers.dart', code: _providerCode),
        CodeSnippet(title: 'intro_page.dart (사용부)', code: _usageCode),
      ],
    );
  }
}

/// 데모 영역: greeting 표시 + counter(watch/read 비교).
class _IntroDemo extends StatelessWidget {
  const _IntroDemo({required this.greeting});

  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('greetingProvider 값:',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(greeting, style: Theme.of(context).textTheme.titleLarge),
                const Divider(height: 24),
                Text('아래 카운터는 ref.watch 로 구독한 부분만 다시 그려집니다.',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                // 카운터 영역만 별도 Consumer 로 분리 → watch 가 이 부분만 rebuild
                const _CounterControls(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // listen 으로 남긴 로그가 여기 실시간으로 찍힌다
        const LifecycleLogView(height: 160),
      ],
    );
  }
}

/// 카운터 표시 + 버튼. Consumer 로 감싸 watch 범위를 좁힌다.
class _CounterControls extends ConsumerWidget {
  const _CounterControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch: count 가 바뀌면 이 Consumer 만 다시 그려진다(부모는 그대로).
    final count = ref.watch(introCounterProvider);
    return Row(
      children: [
        Text('count = $count', style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        FilledButton.icon(
          // read: 버튼을 "눌렀을 때 한 번" notifier 를 읽어 메서드 호출
          onPressed: () => ref.read(introCounterProvider.notifier).increment(),
          icon: const Icon(Icons.add),
          label: const Text('증가'),
        ),
      ],
    );
  }
}

// ── 화면에 표시할 코드 스니펫(실제 코드와 동일하게 유지) ──────────────────────

const String _providerCode = r'''
@riverpod
String greeting(Ref ref) {
  return '안녕하세요, Riverpod 3! 👋';
}

@riverpod
class IntroCounter extends _$IntroCounter {
  @override
  int build() => 0;          // 초기 상태
  void increment() => state++; // 상태 변경 → 구독자 자동 갱신
}
''';

const String _usageCode = r'''
class IntroPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final greeting = ref.watch(greetingProvider); // 구독
    ref.listen(introCounterProvider, (prev, next) {  // 사이드이펙트
      // ...
    });
    // 버튼 콜백에서는 read 로 1회 호출
    // ref.read(introCounterProvider.notifier).increment();
  }
}
''';
