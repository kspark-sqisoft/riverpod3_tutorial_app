// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_value_deep_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 의존(watch) 트리거. 이 값이 바뀌면 [demoData] 가 watch 를 통해 재계산된다 → isReloading.

@ProviderFor(ReloadSeed)
final reloadSeedProvider = ReloadSeedProvider._();

/// 의존(watch) 트리거. 이 값이 바뀌면 [demoData] 가 watch 를 통해 재계산된다 → isReloading.
final class ReloadSeedProvider extends $NotifierProvider<ReloadSeed, int> {
  /// 의존(watch) 트리거. 이 값이 바뀌면 [demoData] 가 watch 를 통해 재계산된다 → isReloading.
  ReloadSeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reloadSeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reloadSeedHash();

  @$internal
  @override
  ReloadSeed create() => ReloadSeed();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$reloadSeedHash() => r'c786798be3ddc037bf21cbf48f384c01fa7b6302';

/// 의존(watch) 트리거. 이 값이 바뀌면 [demoData] 가 watch 를 통해 재계산된다 → isReloading.

abstract class _$ReloadSeed extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// "다음 요청을 일부러 실패시킬지" 플래그 (에러 상태 + skipError 비교용).

@ProviderFor(FailNext)
final failNextProvider = FailNextProvider._();

/// "다음 요청을 일부러 실패시킬지" 플래그 (에러 상태 + skipError 비교용).
final class FailNextProvider extends $NotifierProvider<FailNext, bool> {
  /// "다음 요청을 일부러 실패시킬지" 플래그 (에러 상태 + skipError 비교용).
  FailNextProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'failNextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$failNextHash();

  @$internal
  @override
  FailNext create() => FailNext();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$failNextHash() => r'a7ae5cb7ee696f3b189ee8573a8a838083731551';

/// "다음 요청을 일부러 실패시킬지" 플래그 (에러 상태 + skipError 비교용).

abstract class _$FailNext extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 데모용 비동기 데이터. 800ms 뒤 "데이터 #seed @시각" 을 반환(또는 일부러 실패).
///
///  - reloadSeed 를 watch → 값이 바뀌면 재계산(= 의존 변경, isReloading)
///  - failNext 를 read → 켜져 있으면 이번 build 에서 에러를 던진다(에러 + skipError 비교)
///  - 새로고침(ref.invalidate)으로 부르면 isRefreshing 으로 재계산된다

@ProviderFor(demoData)
final demoDataProvider = DemoDataProvider._();

/// 데모용 비동기 데이터. 800ms 뒤 "데이터 #seed @시각" 을 반환(또는 일부러 실패).
///
///  - reloadSeed 를 watch → 값이 바뀌면 재계산(= 의존 변경, isReloading)
///  - failNext 를 read → 켜져 있으면 이번 build 에서 에러를 던진다(에러 + skipError 비교)
///  - 새로고침(ref.invalidate)으로 부르면 isRefreshing 으로 재계산된다

final class DemoDataProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 데모용 비동기 데이터. 800ms 뒤 "데이터 #seed @시각" 을 반환(또는 일부러 실패).
  ///
  ///  - reloadSeed 를 watch → 값이 바뀌면 재계산(= 의존 변경, isReloading)
  ///  - failNext 를 read → 켜져 있으면 이번 build 에서 에러를 던진다(에러 + skipError 비교)
  ///  - 새로고침(ref.invalidate)으로 부르면 isRefreshing 으로 재계산된다
  DemoDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'demoDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$demoDataHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return demoData(ref);
  }
}

String _$demoDataHash() => r'350b400a7f831180d83743b053706bf33b36366e';
