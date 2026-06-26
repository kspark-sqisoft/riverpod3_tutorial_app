import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'stream_providers.dart';

/// 토픽 7: StreamProvider & StreamNotifier — 시간에 따라 흘러오는 값 다루기.
class StreamPage extends ConsumerWidget {
  const StreamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // StreamProvider 도 결과를 AsyncValue 로 노출한다(새 값이 올 때마다 AsyncData).
    final tickAsync = ref.watch(tickerProvider);
    final stopwatchAsync = ref.watch(stopwatchProvider);

    return ConceptPage(
      title: '7. StreamProvider & StreamNotifier',
      explanation:
          'StreamProvider 는 Stream 을 구독해 새 값이 도착할 때마다 AsyncValue(AsyncData)로 '
          '전달합니다. 함수형(StreamProvider)은 단순 스트림에, 클래스형(StreamNotifier)은 '
          '스트림과 제어 메서드를 함께 둘 때 적합합니다. 화면을 벗어나면 autoDispose 가 '
          '스트림 구독을 자동 취소합니다(이 페이지를 떠났다 오면 값이 0부터 다시 시작).',
      points: const [
        'Stream<T> → AsyncValue<T> (새 이벤트마다 data 갱신)',
        'async* 제너레이터로 값을 계속 yield',
        'autoDispose: 구독자가 없으면 스트림 자동 취소(누수 방지)',
        'StreamNotifier: 스트림 + 메서드가 필요할 때',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text('tickerProvider (StreamProvider)',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              // AsyncValue<int> 를 그대로 표시
              AsyncValueView<int>(
                value: tickAsync,
                data: (value) => Text('$value',
                    style: Theme.of(context).textTheme.displayMedium),
              ),
              const Divider(height: 32),
              Text('stopwatchProvider (StreamNotifier)',
                  style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              AsyncValueView<int>(
                value: stopwatchAsync,
                data: (value) => Text('${value}s',
                    style: Theme.of(context).textTheme.headlineMedium),
              ),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'stream_providers.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
// 함수형 StreamProvider
@riverpod
Stream<int> ticker(Ref ref) async* {
  var count = 0;
  while (true) {
    yield count++;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}

// 클래스형 StreamNotifier
@riverpod
class Stopwatch extends _$Stopwatch {
  @override
  Stream<int> build() async* {
    var s = 0;
    while (true) { yield s++; await Future<void>.delayed(const Duration(seconds: 1)); }
  }
}
''';
