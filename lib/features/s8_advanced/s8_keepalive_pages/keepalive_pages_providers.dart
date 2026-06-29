import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/app_logger.dart';

part 'keepalive_pages_providers.g.dart';

/// autoDispose(기본) 카운터: 구독하던 화면을 떠나면 폐기되고, 다시 오면 0부터 재생성.
@riverpod
class VolatileCounter extends _$VolatileCounter {
  @override
  int build() {
    log.t('🟢 [volatileCounterProvider] build (생성/재생성)');
    ref.onDispose(() =>
        log.i('⚪ [volatileCounterProvider] dispose — autoDispose (값 사라짐)'));
    return 0;
  }

  void increment() => state++;
}

/// keepAlive 카운터: 구독자가 없어도 유지 → 페이지를 옮겨도 값이 그대로.
@Riverpod(keepAlive: true)
class PersistentCounter extends _$PersistentCounter {
  @override
  int build() {
    log.t('🟢 [persistentCounterProvider] build (최초 1회만)');
    ref.onDispose(() =>
        log.i('⚪ [persistentCounterProvider] dispose (앱 종료 등, 거의 안 됨)'));
    return 0;
  }

  void increment() => state++;
}
