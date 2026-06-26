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
    final weatherAsync = ref.watch(weatherProvider(city)); // 도시별 날씨(의존)

    return ConceptPage(
      title: '12. 의존 + 라이프사이클 (도시 → 날씨)',
      explanation:
          '도시를 선택하면 weatherProvider(도시) 가 해당 도시 날씨를 불러옵니다. '
          'weatherProvider 는 다시 unitProvider 에 의존하므로 단위를 바꾸면 자동 재계산됩니다. '
          '도시를 바꾸면 이전 도시의 weather 인스턴스는 구독을 잃어 onRemoveListener → '
          'onCancel → onDispose 로 폐기되고, 새 도시의 weather 가 onAddListener → build 됩니다. '
          '아래 로그에서 이 전 과정을 실시간으로 확인하세요.',
      points: const [
        'selectedCity(Notifier) → weather(city)(family) → UI 로 이어지는 의존 체인',
        'weather 는 unit 에도 의존 → 단위 변경 시 살아있는 weather 가 rebuild',
        '도시 전환 = 이전 인스턴스 폐기 + 새 인스턴스 생성 (autoDispose)',
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
          const LifecycleLogView(height: 220),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'city_weather_providers.dart', code: _code),
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
