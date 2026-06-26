// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keepalive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
/// 다시 구독하면 build 가 재실행되어 새 값(새 시각)이 만들어진다.

@ProviderFor(autoDisposeStamp)
final autoDisposeStampProvider = AutoDisposeStampProvider._();

/// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
/// 다시 구독하면 build 가 재실행되어 새 값(새 시각)이 만들어진다.

final class AutoDisposeStampProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
  /// 다시 구독하면 build 가 재실행되어 새 값(새 시각)이 만들어진다.
  AutoDisposeStampProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoDisposeStampProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoDisposeStampHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return autoDisposeStamp(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$autoDisposeStampHash() => r'1b931c53f0117036a5bccd05d7719a52f06a5e8c';

/// keepAlive: true → 구독자가 없어도 폐기되지 않고 상태가 유지된다.
/// 다시 구독해도 처음 만든 값(시각)이 그대로 유지된다.

@ProviderFor(keepAliveStamp)
final keepAliveStampProvider = KeepAliveStampProvider._();

/// keepAlive: true → 구독자가 없어도 폐기되지 않고 상태가 유지된다.
/// 다시 구독해도 처음 만든 값(시각)이 그대로 유지된다.

final class KeepAliveStampProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// keepAlive: true → 구독자가 없어도 폐기되지 않고 상태가 유지된다.
  /// 다시 구독해도 처음 만든 값(시각)이 그대로 유지된다.
  KeepAliveStampProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keepAliveStampProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keepAliveStampHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return keepAliveStamp(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$keepAliveStampHash() => r'9db6867d17d89c6877cacaa8db24af3882fbbbba';
