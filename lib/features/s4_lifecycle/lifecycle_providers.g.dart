// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifecycle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 라이프사이클 콜백을 모두 등록한 데모 provider (Notifier).
///
/// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
/// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
///
/// 세 가지 동작을 구분해서 보여준다:
///  1) 구독 추가/제거 → onAddListener / onRemoveListener / onCancel / onResume
///  2) 상태 변경(bump) → 아무 라이프사이클 콜백도 안 찍힌다. build 재실행·onDispose 없이
///     리스너에게 "값이 바뀜" 알림만 간다. '생성 @시각'은 그대로, '변경 N회'만 증가.
///  3) 무효화(invalidate) → onDispose 후 build 재실행. '생성 @시각' 갱신, '변경'은 0 으로 리셋.

@ProviderFor(LifecycleDemo)
final lifecycleDemoProvider = LifecycleDemoProvider._();

/// 라이프사이클 콜백을 모두 등록한 데모 provider (Notifier).
///
/// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
/// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
///
/// 세 가지 동작을 구분해서 보여준다:
///  1) 구독 추가/제거 → onAddListener / onRemoveListener / onCancel / onResume
///  2) 상태 변경(bump) → 아무 라이프사이클 콜백도 안 찍힌다. build 재실행·onDispose 없이
///     리스너에게 "값이 바뀜" 알림만 간다. '생성 @시각'은 그대로, '변경 N회'만 증가.
///  3) 무효화(invalidate) → onDispose 후 build 재실행. '생성 @시각' 갱신, '변경'은 0 으로 리셋.
final class LifecycleDemoProvider
    extends $NotifierProvider<LifecycleDemo, String> {
  /// 라이프사이클 콜백을 모두 등록한 데모 provider (Notifier).
  ///
  /// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
  /// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
  ///
  /// 세 가지 동작을 구분해서 보여준다:
  ///  1) 구독 추가/제거 → onAddListener / onRemoveListener / onCancel / onResume
  ///  2) 상태 변경(bump) → 아무 라이프사이클 콜백도 안 찍힌다. build 재실행·onDispose 없이
  ///     리스너에게 "값이 바뀜" 알림만 간다. '생성 @시각'은 그대로, '변경 N회'만 증가.
  ///  3) 무효화(invalidate) → onDispose 후 build 재실행. '생성 @시각' 갱신, '변경'은 0 으로 리셋.
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
  LifecycleDemo create() => LifecycleDemo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$lifecycleDemoHash() => r'b78c95456d4db6fecb937d7389896b5d10844af8';

/// 라이프사이클 콜백을 모두 등록한 데모 provider (Notifier).
///
/// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
/// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
///
/// 세 가지 동작을 구분해서 보여준다:
///  1) 구독 추가/제거 → onAddListener / onRemoveListener / onCancel / onResume
///  2) 상태 변경(bump) → 아무 라이프사이클 콜백도 안 찍힌다. build 재실행·onDispose 없이
///     리스너에게 "값이 바뀜" 알림만 간다. '생성 @시각'은 그대로, '변경 N회'만 증가.
///  3) 무효화(invalidate) → onDispose 후 build 재실행. '생성 @시각' 갱신, '변경'은 0 으로 리셋.

abstract class _$LifecycleDemo extends $Notifier<String> {
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
