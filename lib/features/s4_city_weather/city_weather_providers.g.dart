// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_weather_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 선택된 도시(Notifier). 사용자가 도시를 고르면 여기 상태가 바뀐다.

@ProviderFor(SelectedCity)
final selectedCityProvider = SelectedCityProvider._();

/// 선택된 도시(Notifier). 사용자가 도시를 고르면 여기 상태가 바뀐다.
final class SelectedCityProvider
    extends $NotifierProvider<SelectedCity, String> {
  /// 선택된 도시(Notifier). 사용자가 도시를 고르면 여기 상태가 바뀐다.
  SelectedCityProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCityHash();

  @$internal
  @override
  SelectedCity create() => SelectedCity();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$selectedCityHash() => r'178cfe9234b0481aa2f6cc4f34c089ed6f21f922';

/// 선택된 도시(Notifier). 사용자가 도시를 고르면 여기 상태가 바뀐다.

abstract class _$SelectedCity extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 온도 단위(Notifier). 섭씨/화씨 토글.

@ProviderFor(Unit)
final unitProvider = UnitProvider._();

/// 온도 단위(Notifier). 섭씨/화씨 토글.
final class UnitProvider extends $NotifierProvider<Unit, TempUnit> {
  /// 온도 단위(Notifier). 섭씨/화씨 토글.
  UnitProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitHash();

  @$internal
  @override
  Unit create() => Unit();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TempUnit value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TempUnit>(value),
    );
  }
}

String _$unitHash() => r'19816c9f23ca4fde56f3a76ab786e239223da32b';

/// 온도 단위(Notifier). 섭씨/화씨 토글.

abstract class _$Unit extends $Notifier<TempUnit> {
  TempUnit build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TempUnit, TempUnit>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TempUnit, TempUnit>,
              TempUnit,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// weather(city): 선택 도시의 날씨를 비동기 로드하는 family provider.
///
/// 핵심 학습 포인트:
///  1) family — 도시마다 별도 인스턴스 (weather('서울'), weather('부산')...)
///  2) 의존 체인 — unitProvider 를 watch → 단위가 바뀌면 이 build 재실행
///  3) 라이프사이클 — 도시를 바꾸면 이전 weather(oldCity) 가
///     onRemoveListener → onCancel → onDispose 되고, 새 weather(newCity) 가
///     onAddListener → build 되는 과정을 로그로 직접 확인

@ProviderFor(weather)
final weatherProvider = WeatherFamily._();

/// weather(city): 선택 도시의 날씨를 비동기 로드하는 family provider.
///
/// 핵심 학습 포인트:
///  1) family — 도시마다 별도 인스턴스 (weather('서울'), weather('부산')...)
///  2) 의존 체인 — unitProvider 를 watch → 단위가 바뀌면 이 build 재실행
///  3) 라이프사이클 — 도시를 바꾸면 이전 weather(oldCity) 가
///     onRemoveListener → onCancel → onDispose 되고, 새 weather(newCity) 가
///     onAddListener → build 되는 과정을 로그로 직접 확인

final class WeatherProvider
    extends $FunctionalProvider<AsyncValue<Weather>, Weather, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather> {
  /// weather(city): 선택 도시의 날씨를 비동기 로드하는 family provider.
  ///
  /// 핵심 학습 포인트:
  ///  1) family — 도시마다 별도 인스턴스 (weather('서울'), weather('부산')...)
  ///  2) 의존 체인 — unitProvider 를 watch → 단위가 바뀌면 이 build 재실행
  ///  3) 라이프사이클 — 도시를 바꾸면 이전 weather(oldCity) 가
  ///     onRemoveListener → onCancel → onDispose 되고, 새 weather(newCity) 가
  ///     onAddListener → build 되는 과정을 로그로 직접 확인
  WeatherProvider._({
    required WeatherFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'weatherProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$weatherHash();

  @override
  String toString() {
    return r'weatherProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Weather> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Weather> create(Ref ref) {
    final argument = this.argument as String;
    return weather(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WeatherProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$weatherHash() => r'ceb0559b64609ae08eed0b21689e537ee887a5ea';

/// weather(city): 선택 도시의 날씨를 비동기 로드하는 family provider.
///
/// 핵심 학습 포인트:
///  1) family — 도시마다 별도 인스턴스 (weather('서울'), weather('부산')...)
///  2) 의존 체인 — unitProvider 를 watch → 단위가 바뀌면 이 build 재실행
///  3) 라이프사이클 — 도시를 바꾸면 이전 weather(oldCity) 가
///     onRemoveListener → onCancel → onDispose 되고, 새 weather(newCity) 가
///     onAddListener → build 되는 과정을 로그로 직접 확인

final class WeatherFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Weather>, String> {
  WeatherFamily._()
    : super(
        retry: null,
        name: r'weatherProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// weather(city): 선택 도시의 날씨를 비동기 로드하는 family provider.
  ///
  /// 핵심 학습 포인트:
  ///  1) family — 도시마다 별도 인스턴스 (weather('서울'), weather('부산')...)
  ///  2) 의존 체인 — unitProvider 를 watch → 단위가 바뀌면 이 build 재실행
  ///  3) 라이프사이클 — 도시를 바꾸면 이전 weather(oldCity) 가
  ///     onRemoveListener → onCancel → onDispose 되고, 새 weather(newCity) 가
  ///     onAddListener → build 되는 과정을 로그로 직접 확인

  WeatherProvider call(String city) =>
      WeatherProvider._(argument: city, from: this);

  @override
  String toString() => r'weatherProvider';
}

/// weatherWatched: city 를 "인자로 받지 않고" 내부에서 ref.watch 하는 버전.
///
/// 위 family(weather(city)) 와 비교하기 위한 예시:
///  - family 버전: 도시 전환 = 위젯이 다른 인스턴스를 watch → 구도시 인스턴스가
///    onRemoveListener → onCancel → onDispose 로 폐기되고 새 인스턴스가 build (인스턴스 "교체").
///  - 이 버전: city 를 내부에서 watch 하므로 인스턴스는 "하나"뿐. 도시가 바뀌면
///    같은 인스턴스가 invalidate 되어 onDispose(이전 build 정리) → build 재실행.
///    구독자는 그대로라 onAddListener/onRemoveListener 는 도시 전환 때 찍히지 않는다.

@ProviderFor(weatherWatched)
final weatherWatchedProvider = WeatherWatchedProvider._();

/// weatherWatched: city 를 "인자로 받지 않고" 내부에서 ref.watch 하는 버전.
///
/// 위 family(weather(city)) 와 비교하기 위한 예시:
///  - family 버전: 도시 전환 = 위젯이 다른 인스턴스를 watch → 구도시 인스턴스가
///    onRemoveListener → onCancel → onDispose 로 폐기되고 새 인스턴스가 build (인스턴스 "교체").
///  - 이 버전: city 를 내부에서 watch 하므로 인스턴스는 "하나"뿐. 도시가 바뀌면
///    같은 인스턴스가 invalidate 되어 onDispose(이전 build 정리) → build 재실행.
///    구독자는 그대로라 onAddListener/onRemoveListener 는 도시 전환 때 찍히지 않는다.

final class WeatherWatchedProvider
    extends $FunctionalProvider<AsyncValue<Weather>, Weather, FutureOr<Weather>>
    with $FutureModifier<Weather>, $FutureProvider<Weather> {
  /// weatherWatched: city 를 "인자로 받지 않고" 내부에서 ref.watch 하는 버전.
  ///
  /// 위 family(weather(city)) 와 비교하기 위한 예시:
  ///  - family 버전: 도시 전환 = 위젯이 다른 인스턴스를 watch → 구도시 인스턴스가
  ///    onRemoveListener → onCancel → onDispose 로 폐기되고 새 인스턴스가 build (인스턴스 "교체").
  ///  - 이 버전: city 를 내부에서 watch 하므로 인스턴스는 "하나"뿐. 도시가 바뀌면
  ///    같은 인스턴스가 invalidate 되어 onDispose(이전 build 정리) → build 재실행.
  ///    구독자는 그대로라 onAddListener/onRemoveListener 는 도시 전환 때 찍히지 않는다.
  WeatherWatchedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'weatherWatchedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$weatherWatchedHash();

  @$internal
  @override
  $FutureProviderElement<Weather> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Weather> create(Ref ref) {
    return weatherWatched(ref);
  }
}

String _$weatherWatchedHash() => r'f463e8ad627f3d3f66bb02f0c94f545ca076bd2c';
