import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'keepalive_providers.g.dart';

// 생성 시각을 HH:mm:ss 로 — 재생성되면 값이 바뀌어 "다시 만들어졌는지" 알 수 있다.
String _stamp() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// 상태 = (카운터, 생성 시각).
///  - count     : '+1' 버튼으로 올라가는 값 (재생성되면 0 으로 리셋)
///  - createdAt  : build 된 시각 (재생성되면 갱신)
typedef CounterState = (int count, String createdAt);

/// autoDispose(기본): 구독자가 모두 사라지면 폐기된다.
/// 다시 구독하면 build 가 재실행되어 카운터는 0, 생성 시각도 갱신된다.
@riverpod
class AutoDisposeCounter extends _$AutoDisposeCounter {
  @override
  CounterState build() {
    final at = _stamp();
    log.t('🟢 [autoDisposeCounterProvider] build (생성 @$at · count=0)');
    ref.onDispose(() =>
        log.i('⚪ [autoDisposeCounterProvider] dispose — autoDispose (카운터 사라짐)'));
    return (0, at);
  }

  // 상태만 +1 — 같은 인스턴스 유지(폐기 전까지).
  void increment() {
    final (count, at) = state;
    state = (count + 1, at);
    log.t('🔄 [autoDisposeCounterProvider] count=${count + 1}');
  }
}

/// keepAlive: true → 구독자가 0 이 되어도 폐기되지 않고 상태가 유지된다.
/// 다시 구독해도 카운터와 생성 시각이 그대로 유지된다.
@Riverpod(keepAlive: true)
class KeepAliveCounter extends _$KeepAliveCounter {
  @override
  CounterState build() {
    final at = _stamp();
    log.t('🟢 [keepAliveCounterProvider] build (생성 @$at · count=0)');
    ref.onDispose(
        () => log.i('⚪ [keepAliveCounterProvider] dispose (거의 안 됨)'));
    return (0, at);
  }

  void increment() {
    final (count, at) = state;
    state = (count + 1, at);
    log.t('🔄 [keepAliveCounterProvider] count=${count + 1}');
  }
}
