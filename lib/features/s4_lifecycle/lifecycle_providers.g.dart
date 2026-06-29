// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lifecycle_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 라이프사이클 콜백을 모두 등록한 데모 provider (keepAlive 버전).
///
/// keepAlive: true 라서 "마지막 리스너 제거(onCancel/Paused)" 이후에도 폐기되지 않고
/// 상태가 유지된다. 그래서 재구독하면 onResume 으로 같은 인스턴스가 살아난다.
/// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)
///
/// 아래 [LifecycleDemoAuto](autoDispose 버전)와 나란히 두고 차이를 비교한다.

@ProviderFor(LifecycleDemo)
final lifecycleDemoProvider = LifecycleDemoProvider._();

/// 라이프사이클 콜백을 모두 등록한 데모 provider (keepAlive 버전).
///
/// keepAlive: true 라서 "마지막 리스너 제거(onCancel/Paused)" 이후에도 폐기되지 않고
/// 상태가 유지된다. 그래서 재구독하면 onResume 으로 같은 인스턴스가 살아난다.
/// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)
///
/// 아래 [LifecycleDemoAuto](autoDispose 버전)와 나란히 두고 차이를 비교한다.
final class LifecycleDemoProvider
    extends $NotifierProvider<LifecycleDemo, DemoState> {
  /// 라이프사이클 콜백을 모두 등록한 데모 provider (keepAlive 버전).
  ///
  /// keepAlive: true 라서 "마지막 리스너 제거(onCancel/Paused)" 이후에도 폐기되지 않고
  /// 상태가 유지된다. 그래서 재구독하면 onResume 으로 같은 인스턴스가 살아난다.
  /// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)
  ///
  /// 아래 [LifecycleDemoAuto](autoDispose 버전)와 나란히 두고 차이를 비교한다.
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
  Override overrideWithValue(DemoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoState>(value),
    );
  }
}

String _$lifecycleDemoHash() => r'd71787ac00383b4747427f16bc13f7ce62efdf28';

/// 라이프사이클 콜백을 모두 등록한 데모 provider (keepAlive 버전).
///
/// keepAlive: true 라서 "마지막 리스너 제거(onCancel/Paused)" 이후에도 폐기되지 않고
/// 상태가 유지된다. 그래서 재구독하면 onResume 으로 같은 인스턴스가 살아난다.
/// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)
///
/// 아래 [LifecycleDemoAuto](autoDispose 버전)와 나란히 두고 차이를 비교한다.

abstract class _$LifecycleDemo extends $Notifier<DemoState> {
  DemoState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DemoState, DemoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DemoState, DemoState>,
              DemoState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 위와 동일한 콜백을 가진 autoDispose(기본) 버전.
///
/// keepAlive 버전과 나란히 두고 "마지막 구독 해제" 순간의 차이를 비교한다:
///  - keepAlive  : onCancel(Paused)까지만 — 폐기 안 됨 → 재구독 시 onResume (생성시각 유지)
///  - autoDispose: onCancel → onDispose 로 실제 폐기 → 재구독 시 build 재실행 (생성시각 갱신)

@ProviderFor(LifecycleDemoAuto)
final lifecycleDemoAutoProvider = LifecycleDemoAutoProvider._();

/// 위와 동일한 콜백을 가진 autoDispose(기본) 버전.
///
/// keepAlive 버전과 나란히 두고 "마지막 구독 해제" 순간의 차이를 비교한다:
///  - keepAlive  : onCancel(Paused)까지만 — 폐기 안 됨 → 재구독 시 onResume (생성시각 유지)
///  - autoDispose: onCancel → onDispose 로 실제 폐기 → 재구독 시 build 재실행 (생성시각 갱신)
final class LifecycleDemoAutoProvider
    extends $NotifierProvider<LifecycleDemoAuto, DemoState> {
  /// 위와 동일한 콜백을 가진 autoDispose(기본) 버전.
  ///
  /// keepAlive 버전과 나란히 두고 "마지막 구독 해제" 순간의 차이를 비교한다:
  ///  - keepAlive  : onCancel(Paused)까지만 — 폐기 안 됨 → 재구독 시 onResume (생성시각 유지)
  ///  - autoDispose: onCancel → onDispose 로 실제 폐기 → 재구독 시 build 재실행 (생성시각 갱신)
  LifecycleDemoAutoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lifecycleDemoAutoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lifecycleDemoAutoHash();

  @$internal
  @override
  LifecycleDemoAuto create() => LifecycleDemoAuto();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DemoState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DemoState>(value),
    );
  }
}

String _$lifecycleDemoAutoHash() => r'6bad7461032918f52ee7ff445690e8e48b590fe7';

/// 위와 동일한 콜백을 가진 autoDispose(기본) 버전.
///
/// keepAlive 버전과 나란히 두고 "마지막 구독 해제" 순간의 차이를 비교한다:
///  - keepAlive  : onCancel(Paused)까지만 — 폐기 안 됨 → 재구독 시 onResume (생성시각 유지)
///  - autoDispose: onCancel → onDispose 로 실제 폐기 → 재구독 시 build 재실행 (생성시각 갱신)

abstract class _$LifecycleDemoAuto extends $Notifier<DemoState> {
  DemoState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DemoState, DemoState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DemoState, DemoState>,
              DemoState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
