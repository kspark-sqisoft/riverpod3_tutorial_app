import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'lifecycle_providers.g.dart';

String _now() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// 라이프사이클 데모의 상태 = (카운트, 생성시각).
///  - count     : '상태 변경' 으로 +1 되는 간단한 값
///  - createdAt  : 이 인스턴스가 build 된 시각 (재생성 여부 확인용)
typedef DemoState = (int count, String createdAt);

/// 라이프사이클 콜백을 모두 등록한 데모 provider (keepAlive 버전).
///
/// keepAlive: true 라서 "마지막 리스너 제거(onCancel/Paused)" 이후에도 폐기되지 않고
/// 상태가 유지된다. 그래서 재구독하면 onResume 으로 같은 인스턴스가 살아난다.
/// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)
///
/// 아래 [LifecycleDemoAuto](autoDispose 버전)와 나란히 두고 차이를 비교한다.
@Riverpod(keepAlive: true)
class LifecycleDemo extends _$LifecycleDemo {
  String _createdAt = ''; // 이 인스턴스가 build 된 시각 (재build 되면 갱신)
  int _count = 0; // 상태 변경 횟수 (재build 되면 0 으로 리셋)

  @override
  DemoState build() {
    _createdAt = _now();
    _count = 0;
    log.t('🟢 [lifecycleDemoProvider] build: Uninitialized → Alive (생성 @$_createdAt)');
    ref.onAddListener(() => log.t('➕ [lifecycleDemoProvider] onAddListener: 리스너 추가'));
    ref.onRemoveListener(() => log.t('➖ [lifecycleDemoProvider] onRemoveListener: 리스너 제거'));
    // 마지막 리스너가 사라져도 keepAlive 라 폐기되지 않고 Paused 로 멈춘다.
    ref.onCancel(() => log.w('⏸️ [lifecycleDemoProvider] onCancel: 마지막 리스너 사라짐 → Paused (폐기 안 됨)'));
    ref.onResume(() => log.d('▶️ [lifecycleDemoProvider] onResume: 다시 구독 → Alive'));
    ref.onDispose(() => log.i('⚪ [lifecycleDemoProvider] onDispose: 폐기 (무효화로만 발생)'));
    return (_count, _createdAt);
  }

  /// 상태만 바꾼다 — build 재실행도, onDispose 도 일어나지 않는다. 카운트만 +1.
  void bump() {
    _count++;
    log.t('🔄 [lifecycleDemoProvider] state 변경: 카운트 $_count — build 재실행·onDispose 없이 알림만');
    state = (_count, _createdAt);
  }
}

/// 위와 동일한 콜백을 가진 autoDispose(기본) 버전.
///
/// keepAlive 버전과 나란히 두고 "마지막 구독 해제" 순간의 차이를 비교한다:
///  - keepAlive  : onCancel(Paused)까지만 — 폐기 안 됨 → 재구독 시 onResume (생성시각 유지)
///  - autoDispose: onCancel → onDispose 로 실제 폐기 → 재구독 시 build 재실행 (생성시각 갱신)
@riverpod
class LifecycleDemoAuto extends _$LifecycleDemoAuto {
  String _createdAt = '';
  int _count = 0;

  @override
  DemoState build() {
    _createdAt = _now();
    _count = 0;
    log.t('🟠 [lifecycleDemoAutoProvider] build: Uninitialized → Alive (생성 @$_createdAt)');
    ref.onAddListener(() => log.t('➕ [lifecycleDemoAutoProvider] onAddListener: 리스너 추가'));
    ref.onRemoveListener(() => log.t('➖ [lifecycleDemoAutoProvider] onRemoveListener: 리스너 제거'));
    // 마지막 리스너가 사라지면 곧바로 onDispose 까지 이어진다(autoDispose).
    ref.onCancel(() => log.w('⏸️ [lifecycleDemoAutoProvider] onCancel: 마지막 리스너 사라짐 → 곧 폐기'));
    ref.onResume(() => log.d('▶️ [lifecycleDemoAutoProvider] onResume: 다시 구독 → Alive'));
    ref.onDispose(() => log.i('⚪ [lifecycleDemoAutoProvider] onDispose: 폐기 → Disposed (구독 0 이면 자동)'));
    return (_count, _createdAt);
  }

  void bump() {
    _count++;
    log.t('🔄 [lifecycleDemoAutoProvider] state 변경: 카운트 $_count — build 재실행·onDispose 없이 알림만');
    state = (_count, _createdAt);
  }
}
