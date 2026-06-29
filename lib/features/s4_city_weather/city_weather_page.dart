import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'city_weather_providers.dart';

const List<String> _cities = ['서울', '부산', '제주', '도쿄', '뉴욕'];

/// 토픽 12: 프로바이더 간 의존 + 라이프사이클 (도시 → 날씨).
class CityWeatherPage extends ConsumerWidget {
  const CityWeatherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final city = ref.watch(selectedCityProvider); // 선택된 도시
    final unit = ref.watch(unitProvider); // 현재 단위
    final weatherAsync = ref.watch(weatherProvider(city)); // ① 도시별 날씨(family 인자)
    final weatherWatchedAsync =
        ref.watch(weatherWatchedProvider); // ② 인자 없이 내부에서 watch

    return ConceptPage(
      title: '12. 의존 + 라이프사이클 (도시 → 날씨)',
      explanation:
          '도시를 선택하면 weatherProvider(도시) 가 해당 도시 날씨를 불러옵니다. '
          '여기엔 weather 가 다시 만들어지는 두 가지 경로가 함께 나옵니다. '
          '① city 는 watch 하는 값이 아니라 weather(city) 의 family 인자입니다 — '
          '도시를 바꾸면 위젯이 다른 인스턴스(weather(새도시))를 watch 하게 되고, '
          '이전 weather(구도시) 는 구독을 잃어 onRemoveListener → onCancel → onDispose 로 폐기됩니다(autoDispose). '
          '즉 "같은 weather 가 재생성"이 아니라 인스턴스 자체가 교체되는 것입니다. '
          '② weather 는 unitProvider 를 ref.watch 하므로, 단위를 바꾸면 같은 weather 인스턴스가 '
          '무효화되어 build() 가 처음부터 다시 실행됩니다(인스턴스는 그대로, 값만 재계산). '
          '둘 다 결과는 "이전 상태 폐기 + 새 build" 지만 메커니즘이 다릅니다. '
          '아래 ① family 인자 카드와 ② 인자 없이 watch 하는 카드를 나란히 두었으니, 로그로 두 방식의 차이를 직접 비교해 보세요.',
      points: const [
        'selectedCity(Notifier) → weather(city)(family) → UI 로 이어지는 의존 체인',
        'city 는 watch 가 아니라 family 인자 → 도시 변경 = 다른 인스턴스로 "교체"(이전 인스턴스는 구독을 잃어 autoDispose 폐기)',
        'unit 은 ref.watch 의존 → 단위 변경 = "같은" weather 인스턴스가 invalidate 되어 build 재실행',
        '정리: 둘 다 "폐기 + 새 build" 지만 ①은 인스턴스 교체, ②는 동일 인스턴스 재실행',
        'family 인스턴스마다 독립적인 라이프사이클',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('① family 인자: weatherProvider(city)',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  // 도시 선택 칩
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final c in _cities)
                        ChoiceChip(
                          label: Text(c),
                          selected: c == city,
                          onSelected: (_) =>
                              ref.read(selectedCityProvider.notifier).select(c),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 단위 토글
                  Row(
                    children: [
                      Text('단위: ${unit == TempUnit.celsius ? '섭씨(°C)' : '화씨(°F)'}'),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () => ref.read(unitProvider.notifier).toggle(),
                        icon: const Icon(Icons.swap_horiz),
                        label: const Text('단위 변경'),
                      ),
                    ],
                  ),
                  const Divider(),
                  // 날씨 표시
                  AsyncValueView<Weather>(
                    value: weatherAsync,
                    onRetry: () => ref.invalidate(weatherProvider(city)),
                    data: (w) => ListTile(
                      leading: const Icon(Icons.cloud, size: 36),
                      title: Text('$city 의 날씨',
                          style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(w.display,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // ② 인자 없이 내부에서 watch 하는 버전 — 위 도시 칩/단위 토글을 그대로 공유한다.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('② 인자 없이 watch: weatherWatchedProvider',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    '위의 같은 도시 칩 / 단위 토글을 그대로 씁니다. 이 provider 는 city 를 '
                    '인자로 받지 않고 내부에서 watch 하므로 인스턴스가 "하나"뿐 — 도시를 바꿔도 '
                    '교체가 아니라 같은 인스턴스가 재build 됩니다. 로그에서 [weatherWatched] 는 '
                    '도시 전환 시 onAddListener/onRemoveListener 가 찍히지 않는 것을 확인하세요.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(),
                  AsyncValueView<Weather>(
                    value: weatherWatchedAsync,
                    onRetry: () => ref.invalidate(weatherWatchedProvider),
                    data: (w) => ListTile(
                      leading: const Icon(Icons.cloud_queue, size: 36),
                      title: Text('${w.city} 의 날씨 (watch 버전)',
                          style: Theme.of(context).textTheme.titleMedium),
                      subtitle: Text(w.display,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 240),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'city_weather_providers.dart (① family 인자)', code: _code),
        CodeSnippet(
            title: 'weatherWatched (② 인자 없이 watch)', code: _codeWatched),
      ],
    );
  }
}

const String _code = r'''
@riverpod
class SelectedCity extends _$SelectedCity {
  @override String build() => '서울';
  void select(String city) => state = city;
}

@riverpod
Future<Weather> weather(Ref ref, String city) async {
  final unit = ref.watch(unitProvider);        // 의존: 단위 바뀌면 재실행
  ref.onCancel(() => log('[$city] onCancel'));  // 도시 전환 시 이전 인스턴스
  ref.onDispose(() => log('[$city] onDispose'));// 가 폐기되는 과정 관찰
  await Future.delayed(const Duration(milliseconds: 700));
  return fetchWeather(city, unit);
}

// 사용처
final city = ref.watch(selectedCityProvider);
final weatherAsync = ref.watch(weatherProvider(city));
''';

const String _codeWatched = r'''
// city 를 인자로 받지 않고 내부에서 watch 하는 버전 — 인스턴스는 "하나"뿐
@riverpod
Future<Weather> weatherWatched(Ref ref) async {
  final city = ref.watch(selectedCityProvider);  // 인자 대신 watch
  final unit = ref.watch(unitProvider);
  // 도시가 바뀌면 같은 인스턴스가 invalidate → onDispose(이전 build 정리) → build 재실행.
  // 구독은 그대로라 onAddListener/onRemoveListener 는 도시 전환 때 찍히지 않는다.
  ref.onDispose(() => log('[weatherWatched] onDispose (이전 build 정리)'));
  await Future.delayed(const Duration(milliseconds: 700));
  return fetchWeather(city, unit);
}

// 사용처 — family 와 달리 인자가 없다
final weatherAsync = ref.watch(weatherWatchedProvider);
''';
