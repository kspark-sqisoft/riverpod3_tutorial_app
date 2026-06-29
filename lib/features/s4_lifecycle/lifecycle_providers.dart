import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'lifecycle_providers.g.dart';

String _now() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

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
@Riverpod(keepAlive: true)
class LifecycleDemo extends _$LifecycleDemo {
  String _createdAt = ''; // 이 인스턴스가 build 된 시각 (재build 되면 갱신)
  int _count = 0; // 상태 변경 횟수 (재build 되면 0 으로 리셋)

  @override
  String build() {
    _createdAt = _now();
    _count = 0;
    log.t('🟢 build: Uninitialized → Alive (provider 생성 @$_createdAt)');
    // 리스너가 하나 추가될 때마다
    ref.onAddListener(() => log.t('➕ onAddListener: 리스너 추가'));
    // 리스너가 하나 제거될 때마다
    ref.onRemoveListener(() => log.t('➖ onRemoveListener: 리스너 제거'));
    // 마지막 리스너가 사라져 더 이상 구독자가 없을 때 (Paused)
    ref.onCancel(() => log.w('⏸️ onCancel: 마지막 리스너 사라짐 → Paused'));
    // 다시 구독자가 생겨 살아날 때 (Alive)
    ref.onResume(() => log.d('▶️ onResume: 다시 구독 → Alive'));
    // 완전히 폐기될 때 (Disposed)
    ref.onDispose(() => log.i('⚪ onDispose: 폐기 → Disposed'));
    return '생성 @$_createdAt · 변경 0회';
  }

  /// 상태만 바꾼다 — build 재실행도, onDispose 도 일어나지 않는다.
  /// 리스너에게는 "값이 바뀌었다"는 알림만 가서 UI 만 다시 그려진다.
  /// '생성 @시각'은 그대로인데 '변경 N회'만 올라가는 것으로 "재생성이 아님"을 확인할 수 있다.
  void bump() {
    _count++;
    log.t('🔄 state 변경: 변경 $_count회 — build 재실행·onDispose 없이 리스너에 알림만');
    state = '생성 @$_createdAt · 변경 $_count회';
  }
}
