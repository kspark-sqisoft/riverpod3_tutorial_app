import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'city_weather_providers.g.dart';

/// 온도 단위.
enum TempUnit { celsius, fahrenheit }

/// 날씨 데이터(불변).
class Weather {
  const Weather({
    required this.city,
    required this.temp,
    required this.unit,
    required this.condition,
  });

  final String city;
  final int temp;
  final TempUnit unit;
  final String condition;

  String get display =>
      '$temp°${unit == TempUnit.celsius ? 'C' : 'F'} · $condition';
}

/// 선택된 도시(Notifier). 사용자가 도시를 고르면 여기 상태가 바뀐다.
@riverpod
class SelectedCity extends _$SelectedCity {
  @override
  String build() => '서울';

  void select(String city) => state = city;
}

/// 온도 단위(Notifier). 섭씨/화씨 토글.
@riverpod
class Unit extends _$Unit {
  @override
  TempUnit build() => TempUnit.celsius;

  void toggle() => state =
      state == TempUnit.celsius ? TempUnit.fahrenheit : TempUnit.celsius;
}

// 도시별 기준 기온(섭씨)과 날씨 상태 — 외부 API 키 없이 쓰는 모의 데이터.
const Map<String, int> _baseTempC = {
  '서울': 18,
  '부산': 22,
  '제주': 24,
  '도쿄': 20,
  '뉴욕': 15,
};
const Map<String, String> _condition = {
  '서울': '맑음',
  '부산': '구름조금',
  '제주': '흐림',
  '도쿄': '비',
  '뉴욕': '바람',
};

/// weather(city): 선택 도시의 날씨를 비동기 로드하는 family provider.
///
/// 핵심 학습 포인트:
///  1) family — 도시마다 별도 인스턴스 (weather('서울'), weather('부산')...)
///  2) 의존 체인 — unitProvider 를 watch → 단위가 바뀌면 이 build 재실행
///  3) 라이프사이클 — 도시를 바꾸면 이전 weather(oldCity) 가
///     onRemoveListener → onCancel → onDispose 되고, 새 weather(newCity) 가
///     onAddListener → build 되는 과정을 로그로 직접 확인
@riverpod
Future<Weather> weather(Ref ref, String city) async {
  final unit = ref.watch(unitProvider); // 의존: 단위 변경 시 재실행
  log.t('🟢 [weather($city)] build 시작 (unit=$unit)');

  // 이 family 인스턴스의 라이프사이클 콜백 등록
  ref.onAddListener(() => log.t('➕ [weather($city)] onAddListener'));
  ref.onRemoveListener(() => log.t('➖ [weather($city)] onRemoveListener'));
  ref.onCancel(() => log.w('⏸️ [weather($city)] onCancel (구독 0)'));
  ref.onResume(() => log.d('▶️ [weather($city)] onResume'));
  ref.onDispose(() => log.i('⚪ [weather($city)] onDispose (폐기)'));

  // 모의 비동기 호출(네트워크 흉내)
  await Future<void>.delayed(const Duration(milliseconds: 700));
  final baseC = _baseTempC[city] ?? 20;
  final temp =
      unit == TempUnit.celsius ? baseC : (baseC * 9 / 5 + 32).round();
  final w = Weather(
    city: city,
    temp: temp,
    unit: unit,
    condition: _condition[city] ?? '맑음',
  );
  log.i('🌡️ [weather($city)] 로드 완료: ${w.display}');
  return w;
}

/// weatherWatched: city 를 "인자로 받지 않고" 내부에서 ref.watch 하는 버전.
///
/// 위 family(weather(city)) 와 비교하기 위한 예시:
///  - family 버전: 도시 전환 = 위젯이 다른 인스턴스를 watch → 구도시 인스턴스가
///    onRemoveListener → onCancel → onDispose 로 폐기되고 새 인스턴스가 build (인스턴스 "교체").
///  - 이 버전: city 를 내부에서 watch 하므로 인스턴스는 "하나"뿐. 도시가 바뀌면
///    같은 인스턴스가 invalidate 되어 onDispose(이전 build 정리) → build 재실행.
///    구독자는 그대로라 onAddListener/onRemoveListener 는 도시 전환 때 찍히지 않는다.
@riverpod
Future<Weather> weatherWatched(Ref ref) async {
  final city = ref.watch(selectedCityProvider); // 인자 대신 watch → 도시 바뀌면 재build
  final unit = ref.watch(unitProvider); // 단위도 watch → 바뀌면 재build
  log.t('🟣 [weatherWatched] build 시작 (city=$city, unit=$unit)');

  // family 버전과 같은 콜백을 달아 두고 "무엇이 찍히는지"를 비교한다.
  ref.onAddListener(() => log.t('➕ [weatherWatched] onAddListener'));
  ref.onRemoveListener(() => log.t('➖ [weatherWatched] onRemoveListener'));
  ref.onCancel(() => log.w('⏸️ [weatherWatched] onCancel (구독 0)'));
  ref.onResume(() => log.d('▶️ [weatherWatched] onResume'));
  ref.onDispose(() => log.i('⚪ [weatherWatched] onDispose (이전 build 정리 or 폐기)'));

  await Future<void>.delayed(const Duration(milliseconds: 700));
  final baseC = _baseTempC[city] ?? 20;
  final temp =
      unit == TempUnit.celsius ? baseC : (baseC * 9 / 5 + 32).round();
  final w = Weather(
    city: city,
    temp: temp,
    unit: unit,
    condition: _condition[city] ?? '맑음',
  );
  log.i('🌡️ [weatherWatched] 로드 완료: ${w.display}');
  return w;
}
