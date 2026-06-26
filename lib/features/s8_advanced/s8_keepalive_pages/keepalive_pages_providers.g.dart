// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keepalive_pages_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// autoDispose(기본) 카운터: 구독하던 화면을 떠나면 폐기되고, 다시 오면 0부터 재생성.

@ProviderFor(VolatileCounter)
final volatileCounterProvider = VolatileCounterProvider._();

/// autoDispose(기본) 카운터: 구독하던 화면을 떠나면 폐기되고, 다시 오면 0부터 재생성.
final class VolatileCounterProvider
    extends $NotifierProvider<VolatileCounter, int> {
  /// autoDispose(기본) 카운터: 구독하던 화면을 떠나면 폐기되고, 다시 오면 0부터 재생성.
  VolatileCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'volatileCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$volatileCounterHash();

  @$internal
  @override
  VolatileCounter create() => VolatileCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$volatileCounterHash() => r'2c5fbe85eae425c21f916159bccdb4fd1489001a';

/// autoDispose(기본) 카운터: 구독하던 화면을 떠나면 폐기되고, 다시 오면 0부터 재생성.

abstract class _$VolatileCounter extends $Notifier<int> {
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

/// keepAlive 카운터: 구독자가 없어도 유지 → 페이지를 옮겨도 값이 그대로.

@ProviderFor(PersistentCounter)
final persistentCounterProvider = PersistentCounterProvider._();

/// keepAlive 카운터: 구독자가 없어도 유지 → 페이지를 옮겨도 값이 그대로.
final class PersistentCounterProvider
    extends $NotifierProvider<PersistentCounter, int> {
  /// keepAlive 카운터: 구독자가 없어도 유지 → 페이지를 옮겨도 값이 그대로.
  PersistentCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'persistentCounterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$persistentCounterHash();

  @$internal
  @override
  PersistentCounter create() => PersistentCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$persistentCounterHash() => r'edf940e14cfe41612687c6dff80bed6ca05b2a28';

/// keepAlive 카운터: 구독자가 없어도 유지 → 페이지를 옮겨도 값이 그대로.

abstract class _$PersistentCounter extends $Notifier<int> {
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
