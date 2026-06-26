import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../shared/app_logger.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';
import '../shared/async_state_view.dart';

enum TempUnit { celsius, fahrenheit }

class Weather {
  const Weather(this.city, this.temp, this.unit, this.condition);
  final String city;
  final int temp;
  final TempUnit unit;
  final String condition;
  String get display =>
      '$temp°${unit == TempUnit.celsius ? 'C' : 'F'} · $condition';
}

const _baseTempC = {'서울': 18, '부산': 22, '제주': 24, '도쿄': 20, '뉴욕': 15};
const _cond = {'서울': '맑음', '부산': '구름조금', '제주': '흐림', '도쿄': '비', '뉴욕': '바람'};
const _cities = ['서울', '부산', '제주', '도쿄', '뉴욕'];

final _selectedCity = signal('서울'); // 선택 도시
final _unit = signal(TempUnit.celsius); // 단위

// futureSignal: 콜백 시작부에서 두 signal 을 읽으므로 자동 추적된다.
// → 도시나 단위가 바뀌면 이 비동기 작업이 자동으로 다시 실행된다(의존 추적).
final _weather = futureSignal(() async {
  final city = _selectedCity.value; // 읽으면 추적
  final unit = _unit.value; // 읽으면 추적
  log.t('🟢 [signals weather] build 시작: city=$city, unit=$unit');
  await Future<void>.delayed(const Duration(milliseconds: 700));
  final baseC = _baseTempC[city] ?? 20;
  final temp = unit == TempUnit.celsius ? baseC : (baseC * 9 / 5 + 32).round();
  final w = Weather(city, temp, unit, _cond[city] ?? '맑음');
  log.i('🌡️ [signals weather] 완료: ${w.display}');
  return w;
});

/// 토픽 30: 의존 체인 (도시→날씨). signals 의 자동 의존 추적. (Riverpod 토픽 12 대응)
class DependencyPage extends StatelessWidget {
  const DependencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '30. 의존 체인 (도시 → 날씨)',
      explanation:
          'signals 는 콜백에서 읽은 signal 을 자동 추적합니다. 아래 weather futureSignal 은 시작부에서 '
          'selectedCity 와 unit 을 읽으므로, 둘 중 하나만 바뀌어도 자동으로 다시 계산됩니다. '
          'Riverpod 의 ref.watch 의존(토픽 12)과 같은 결과지만, signals 는 "읽으면 곧 의존"이라 더 '
          '암묵적입니다. 다만 Riverpod 의 family·라이프사이클 콜백(onDispose 등 도시별 인스턴스 '
          '폐기 관찰)에 해당하는 기능은 없습니다(차이 → 토픽 33).',
      points: const [
        'signals: 콜백에서 읽은 signal 자동 추적 → 변경 시 자동 재실행',
        'await 이전에 읽어야 추적됨(이후 읽기는 dependencies 옵션 필요)',
        'Riverpod 토픽 12와 같은 의존 결과, 더 암묵적',
        'family/도시별 라이프사이클 관찰은 signals 엔 없음(토픽 33)',
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
                  SignalBuilder(builder:(context) => Wrap(
                        spacing: 8,
                        children: [
                          for (final c in _cities)
                            ChoiceChip(
                              label: Text(c),
                              selected: c == _selectedCity.value,
                              onSelected: (_) => _selectedCity.value = c,
                            ),
                        ],
                      )),
                  const SizedBox(height: 8),
                  SignalBuilder(builder:(context) => Row(
                        children: [
                          Text('단위: ${_unit.value == TempUnit.celsius ? '섭씨(°C)' : '화씨(°F)'}'),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: () => _unit.value =
                                _unit.value == TempUnit.celsius
                                    ? TempUnit.fahrenheit
                                    : TempUnit.celsius,
                            icon: const Icon(Icons.swap_horiz),
                            label: const Text('단위 변경'),
                          ),
                        ],
                      )),
                  const Divider(),
                  SignalBuilder(builder:(context) => AsyncStateView<Weather>(
                        state: _weather.value,
                        onRetry: () => _weather.reload(),
                        data: (w) => ListTile(
                          leading: const Icon(Icons.cloud, size: 36),
                          title: SignalBuilder(builder:(context) => Text('${_selectedCity.value} 의 날씨')),
                          subtitle: Text(w.display,
                              style: Theme.of(context).textTheme.headlineSmall),
                        ),
                      )),
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
final selectedCity = signal('서울');
final unit = signal(TempUnit.celsius);

final weather = futureSignal(() async {
  final city = selectedCity.value;   // 읽으면 자동 추적
  final u = unit.value;              // (await 이전에 읽어야 함)
  await Future.delayed(...);
  return fetchWeather(city, u);
});
// city 나 unit 을 바꾸면 weather 가 자동으로 다시 계산됨
''';

const String _riverpodCode = r'''
@riverpod
Future<Weather> weather(Ref ref, String city) async {
  final unit = ref.watch(unitProvider);  // 명시적 watch
  return fetchWeather(city, unit);
}
// + family 인스턴스별 onCancel/onDispose 라이프사이클 관찰(토픽 12)
''';
