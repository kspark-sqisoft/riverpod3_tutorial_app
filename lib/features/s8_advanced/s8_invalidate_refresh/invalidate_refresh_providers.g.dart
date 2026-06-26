// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invalidate_refresh_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 호출(build)될 때마다 카운트를 올리는 provider.
/// invalidate/refresh 로 "재계산이 일어나는지"를 값 증가로 관찰한다.

@ProviderFor(rebuildCounter)
final rebuildCounterProvider = RebuildCounterProvider._();

/// 호출(build)될 때마다 카운트를 올리는 provider.
/// invalidate/refresh 로 "재계산이 일어나는지"를 값 증가로 관찰한다.

final class RebuildCounterProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// 호출(build)될 때마다 카운트를 올리는 provider.
  /// invalidate/refresh 로 "재계산이 일어나는지"를 값 증가로 관찰한다.
  RebuildCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rebuildCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rebuildCounterHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return rebuildCounter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$rebuildCounterHash() => r'1d862d1377356cdf2ea655d3b65bac86546c8bdb';
