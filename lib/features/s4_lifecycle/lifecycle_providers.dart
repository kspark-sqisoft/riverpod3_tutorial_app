import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'lifecycle_providers.g.dart';

String _now() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// 라이프사이클 콜백을 모두 등록한 데모 provider.
///
/// keepAlive: true 로 두어 "마지막 리스너 제거(onCancel/Paused)"와
/// "재구독(onResume)"을 폐기 없이 또렷하게 관찰할 수 있게 한다.
/// (onDispose 는 화면의 '무효화' 버튼으로 직접 유발한다.)
@Riverpod(keepAlive: true)
String lifecycleDemo(Ref ref) {
  log.t('🟢 build: Uninitialized → Alive (provider 생성)');
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
  return '생성 시각 ${_now()}';
}
