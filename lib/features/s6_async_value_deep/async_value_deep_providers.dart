import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'async_value_deep_providers.g.dart';

String _now() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// 의존(watch) 트리거. 이 값이 바뀌면 [demoData] 가 watch 를 통해 재계산된다 → isReloading.
@riverpod
class ReloadSeed extends _$ReloadSeed {
  @override
  int build() => 1;

  void bump() => state++;
}

/// "다음 요청을 일부러 실패시킬지" 플래그 (에러 상태 + skipError 비교용).
@riverpod
class FailNext extends _$FailNext {
  @override
  bool build() => false;

  void setValue(bool v) => state = v;
}

/// 데모용 비동기 데이터. 800ms 뒤 "데이터 #seed @시각" 을 반환(또는 일부러 실패).
///
///  - reloadSeed 를 watch → 값이 바뀌면 재계산(= 의존 변경, isReloading)
///  - failNext 를 read → 켜져 있으면 이번 build 에서 에러를 던진다(에러 + skipError 비교)
///  - 새로고침(ref.invalidate)으로 부르면 isRefreshing 으로 재계산된다
@riverpod
Future<String> demoData(Ref ref) async {
  final seed = ref.watch(reloadSeedProvider);
  final fail = ref.read(failNextProvider);
  log.t('🟢 [demoDataProvider] build 시작 (seed=$seed, fail=$fail)');
  await Future<void>.delayed(const Duration(milliseconds: 800)); // 로딩 체감용
  if (fail) {
    log.w('❌ [demoDataProvider] 의도적 실패');
    throw Exception('일부러 낸 에러 (seed=$seed)');
  }
  final r = '데이터 #$seed @${_now()}';
  log.i('🟢 [demoDataProvider] 완료: $r');
  return r;
}
