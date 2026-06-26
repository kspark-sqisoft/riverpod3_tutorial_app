import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';

// 전역 signal — Riverpod 의 provider 대신, 상태를 그냥 전역 변수로 둔다.
// signal 은 "값을 담는 반응형 컨테이너"로, .value 로 읽고 쓴다.
final _counter = signal(0);

/// 토픽 25: signal 기본 — 두 가지 구독(소비) 방식: SignalBuilder, SignalWidget.
class SignalBasicsPage extends StatelessWidget {
  const SignalBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '25. signal 기본 (SignalBuilder & SignalWidget)',
      explanation:
          'signal(0) 으로 만들고 .value 로 읽고/씁니다. UI 에서 signal 변경에 반응하는 방법은 두 가지가 '
          '있습니다. ① SignalBuilder(builder:(context) => ...) 로 일부만 감싸기(미세 리빌드). '
          '② 위젯을 SignalWidget 으로 만들고 build 에서 .value 를 그냥 읽기 — 이게 공식 기본 예제 '
          '스타일로, 별도 래퍼 없이 자동 추적됩니다(읽은 signal 이 바뀌면 그 위젯이 rebuild). '
          '(참고: 예전의 Watch/.watch/SignalsMixin 은 deprecated → SignalBuilder/SignalWidget 권장.)',
      points: const [
        'signal(0): 반응형 값 컨테이너 (.value 로 읽기/쓰기)',
        '① SignalBuilder(builder: ...): 감싼 부분만 rebuild(부분 구독)',
        '② SignalWidget 상속: build 에서 .value 만 읽으면 자동 추적(래퍼 불필요)',
        'Riverpod 대비: 전역 선언, build_runner/Provider 불필요',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ① SignalBuilder 방식
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('① SignalBuilder 방식',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  // 이 빌더 안에서 읽은 _counter 가 바뀌면 이 부분만 다시 그려진다
                  SignalBuilder(
                      builder: (context) => Text('count = ${_counter.value}',
                          style: Theme.of(context).textTheme.headlineMedium)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ② SignalWidget 방식 (SignalBuilder 없이 .value 직접 읽기)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('② SignalWidget 방식 (래퍼 없이 .value)',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 4),
                  const _CounterText(), // 내부 build 에서 .value 직접 읽음 → 자동 추적
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 공통 버튼 — 두 방식 모두 동시에 갱신된다
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => _counter.value = 0, // 직접 쓰기
                child: const Text('리셋'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: () => _counter.value++, // 직접 증가
                icon: const Icon(Icons.add),
                label: const Text('증가'),
              ),
            ],
          ),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'signals — ① SignalBuilder', code: _builderCode),
        CodeSnippet(title: 'signals — ② SignalWidget', code: _widgetCode),
        CodeSnippet(title: 'Riverpod (대응)', code: _riverpodCode),
      ],
    );
  }
}

/// SignalWidget 을 상속하면 build 에서 읽은 signal 을 자동 추적한다(SignalBuilder 불필요).
class _CounterText extends SignalWidget {
  const _CounterText();

  @override
  Widget build(BuildContext context) {
    // .value 를 그냥 읽기만 해도 _counter 변경 시 이 위젯이 다시 그려진다.
    return Text('count = ${_counter.value}',
        style: Theme.of(context).textTheme.headlineMedium);
  }
}

const String _builderCode = r'''
final counter = signal(0);

// 일부만 감싸 미세 리빌드
SignalBuilder(builder: (context) => Text('${counter.value}'));
counter.value++;            // 직접 쓰기
''';

const String _widgetCode = r'''
// 위젯을 SignalWidget 으로 → build 에서 .value 읽으면 자동 추적(래퍼 불필요)
class CounterText extends SignalWidget {
  const CounterText({super.key});
  @override
  Widget build(BuildContext context) => Text('${counter.value}');
}
''';

const String _riverpodCode = r'''
@riverpod
class Counter extends _$Counter {
  @override int build() => 0;
  void increment() => state++;
}

final c = ref.watch(counterProvider);   // 구독(ConsumerWidget)
ref.read(counterProvider.notifier).increment();
''';
