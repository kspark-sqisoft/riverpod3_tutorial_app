import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/app_logger.dart';

part 'mounted_providers.g.dart';

String _now() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// ref.mounted 데모: 느린 비동기 작업 도중 provider 가 폐기될 수 있는 상황.
///
/// autoDispose(기본) provider 라서, 작업(await) 중에 사용자가 화면을 떠나면 폐기된다.
/// await 뒤에 state 를 그대로 갱신하면 "폐기된 provider 를 갱신"하게 되어 위험하다.
/// → ref.mounted 로 아직 살아있는지 확인하고, 아니면 안전하게 중단한다.
@riverpod
class SlowTask extends _$SlowTask {
  @override
  String build() {
    ref.onDispose(() => log.i('⚪ slowTask 폐기됨 (화면 이탈 등)'));
    return '대기 중 — 버튼을 눌러 시작하세요';
  }

  Future<void> run() async {
    state = '⏳ 3초 작업 중... 지금 다른 토픽으로 갔다 오면 이 provider 가 폐기됩니다';
    log.t('▶️ slowTask.run() 시작 — 3초 대기');
    await Future<void>.delayed(const Duration(seconds: 3));

    // 핵심: await 뒤에는 provider 가 살아있다는 보장이 없다.
    log.i('await 완료 → ref.mounted = ${ref.mounted}');
    if (!ref.mounted) {
      // 폐기됐다면 state 갱신을 하지 않는다(StateError 방지).
      log.w('🛑 ref.mounted == false → 폐기됨, 상태 갱신 중단(안전)');
      return;
    }
    state = '✅ 완료 (${_now()}) — provider 가 살아있어 정상 갱신';
    log.i('✅ ref.mounted == true → 상태 갱신 완료');
  }
}
