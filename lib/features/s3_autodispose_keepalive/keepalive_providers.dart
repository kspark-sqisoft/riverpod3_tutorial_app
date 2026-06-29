import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'keepalive_providers.g.dart';

// 생성 시각을 HH:mm:ss 로 — 재생성되면 값이 바뀌어 "다시 만들어졌는지" 알 수 있다.
String _stamp() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
/// 다시 구독하면 build 가 재실행되어 새 값(새 시각)이 만들어진다.
@riverpod
String autoDisposeStamp(Ref ref) {
  log.t('🟢 [autoDisposeStampProvider] build');
  ref.onDispose(() => log.i('⚪ [autoDisposeStampProvider] dispose'));
  return _stamp();
}

/// keepAlive: true → 구독자가 없어도 폐기되지 않고 상태가 유지된다.
/// 다시 구독해도 처음 만든 값(시각)이 그대로 유지된다.
@Riverpod(keepAlive: true)
String keepAliveStamp(Ref ref) {
  log.t('🟢 [keepAliveStampProvider] build');
  ref.onDispose(() => log.i('⚪ [keepAliveStampProvider] dispose'));
  return _stamp();
}
