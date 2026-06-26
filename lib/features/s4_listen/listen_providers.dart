import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'listen_providers.g.dart';

/// 사이드이펙트 데모용 카운터.
@riverpod
class EventCounter extends _$EventCounter {
  @override
  int build() {
    // listenSelf: provider "내부"에서 자기 상태 변화를 감지한다.
    // (로깅, 영속화, 분석 이벤트 전송 등 내부 사이드이펙트에 유용)
    listenSelf((previous, next) {
      log.d('🪝 listenSelf: $previous → $next');
    });
    return 0;
  }

  void increment() => state++;
  void reset() => state = 0;
}
