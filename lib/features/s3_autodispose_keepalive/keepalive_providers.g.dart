// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keepalive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
/// 다시 구독하면 build 가 재실행되어 카운터는 0, 생성 시각도 갱신된다.

@ProviderFor(AutoDisposeCounter)
final autoDisposeCounterProvider = AutoDisposeCounterProvider._();

/// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
/// 다시 구독하면 build 가 재실행되어 카운터는 0, 생성 시각도 갱신된다.
final class AutoDisposeCounterProvider
    extends $NotifierProvider<AutoDisposeCounter, CounterState> {
  /// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
  /// 다시 구독하면 build 가 재실행되어 카운터는 0, 생성 시각도 갱신된다.
  AutoDisposeCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoDisposeCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoDisposeCounterHash();

  @$internal
  @override
  AutoDisposeCounter create() => AutoDisposeCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CounterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CounterState>(value),
    );
  }
}

String _$autoDisposeCounterHash() =>
    r'7c9649a232d39d98a8b414d797eeb34afe24584c';

/// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
/// 다시 구독하면 build 가 재실행되어 카운터는 0, 생성 시각도 갱신된다.

abstract class _$AutoDisposeCounter extends $Notifier<CounterState> {
  CounterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CounterState, CounterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CounterState, CounterState>,
              CounterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// keepAlive: true → 구독자가 0 이 되어도 폐기되지 않고 상태가 유지된다.
/// 다시 구독해도 카운터와 생성 시각이 그대로 유지된다.

@ProviderFor(KeepAliveCounter)
final keepAliveCounterProvider = KeepAliveCounterProvider._();

/// keepAlive: true → 구독자가 0 이 되어도 폐기되지 않고 상태가 유지된다.
/// 다시 구독해도 카운터와 생성 시각이 그대로 유지된다.
final class KeepAliveCounterProvider
    extends $NotifierProvider<KeepAliveCounter, CounterState> {
  /// keepAlive: true → 구독자가 0 이 되어도 폐기되지 않고 상태가 유지된다.
  /// 다시 구독해도 카운터와 생성 시각이 그대로 유지된다.
  KeepAliveCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keepAliveCounterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keepAliveCounterHash();

  @$internal
  @override
  KeepAliveCounter create() => KeepAliveCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CounterState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CounterState>(value),
    );
  }
}

String _$keepAliveCounterHash() => r'2ba63abf901bc7a5f1cc27bc1623f4a1af88e1eb';

/// keepAlive: true → 구독자가 0 이 되어도 폐기되지 않고 상태가 유지된다.
/// 다시 구독해도 카운터와 생성 시각이 그대로 유지된다.

abstract class _$KeepAliveCounter extends $Notifier<CounterState> {
  CounterState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<CounterState, CounterState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<CounterState, CounterState>,
              CounterState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
