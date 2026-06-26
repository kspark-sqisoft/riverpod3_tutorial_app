// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifecycle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 라이프사이클 콜백을 모두 등록한 데모 provider.
///
/// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
/// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
/// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)

@ProviderFor(lifecycleDemo)
final lifecycleDemoProvider = LifecycleDemoProvider._();

/// 라이프사이클 콜백을 모두 등록한 데모 provider.
///
/// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
/// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
/// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)

final class LifecycleDemoProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 라이프사이클 콜백을 모두 등록한 데모 provider.
  ///
  /// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
  /// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
  /// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)
  LifecycleDemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lifecycleDemoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lifecycleDemoHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return lifecycleDemo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$lifecycleDemoHash() => r'16dc6a8efc56a74d65cd39033a8327d6e565a19a';
