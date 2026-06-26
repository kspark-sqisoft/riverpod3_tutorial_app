// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// dummyjson 클라이언트를 공급하는 provider.
///
/// 여러 토픽이 공유하는 "인프라"이므로 keepAlive: true 로 항상 살아있게 둔다.
/// 테스트에서는 이 provider 를 override 해 가짜 클라이언트를 주입할 수 있다(토픽 20).

@ProviderFor(dummyJsonClient)
final dummyJsonClientProvider = DummyJsonClientProvider._();

/// dummyjson 클라이언트를 공급하는 provider.
///
/// 여러 토픽이 공유하는 "인프라"이므로 keepAlive: true 로 항상 살아있게 둔다.
/// 테스트에서는 이 provider 를 override 해 가짜 클라이언트를 주입할 수 있다(토픽 20).

final class DummyJsonClientProvider
    extends
        $FunctionalProvider<DummyJsonClient, DummyJsonClient, DummyJsonClient>
    with $Provider<DummyJsonClient> {
  /// dummyjson 클라이언트를 공급하는 provider.
  ///
  /// 여러 토픽이 공유하는 "인프라"이므로 keepAlive: true 로 항상 살아있게 둔다.
  /// 테스트에서는 이 provider 를 override 해 가짜 클라이언트를 주입할 수 있다(토픽 20).
  DummyJsonClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dummyJsonClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dummyJsonClientHash();

  @$internal
  @override
  $ProviderElement<DummyJsonClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DummyJsonClient create(Ref ref) {
    return dummyJsonClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DummyJsonClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DummyJsonClient>(value),
    );
  }
}

String _$dummyJsonClientHash() => r'99dc7f29c5891f18bfc4f277cda287970567a83e';
