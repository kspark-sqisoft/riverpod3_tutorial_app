import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/app_logger.dart';

/// 앱 전역 ProviderObserver.
///
/// `ProviderScope(observers: [LifecycleObserver()])` 로 등록하면
/// 모든 provider 의 생성/갱신/폐기/실패 이벤트를 가로채 [AppLogger] 로 보낸다.
/// → 콘솔과 화면 로그에 동시에 찍혀 라이프사이클을 "눈으로" 확인할 수 있다.
///
/// 주의(Riverpod 3.x): 콜백 시그니처가 [ProviderObserverContext] 를 받는 형태로 바뀌었다.
/// ProviderObserver 는 `abstract base class` 라서 반드시 `extends` 해야 한다.
final class LifecycleObserver extends ProviderObserver {
  const LifecycleObserver();

  // provider 의 표시용 이름.
  //
  // 코드생성 provider 의 정규 이름은 'weatherProvider' 처럼 'Provider' 로 끝난다.
  // 화면 로그는 이 정규 이름으로 통일한다 — provider 가 build 안에서 직접 남기는
  // 손글씨 로그도 같은 'xxxProvider' 태그를 쓰므로, observer 와 손글씨가 한 이름으로 보인다.
  // family 인스턴스면 인자를 붙여 어떤 인스턴스인지 구분한다: 'weatherProvider(서울)'.
  String _name(ProviderObserverContext context) {
    final provider = context.provider;
    final name = provider.name ?? provider.runtimeType.toString();
    final argument = provider.argument;
    return argument == null ? name : '$name($argument)';
  }

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) {
    // provider 가 처음 초기화됨(Uninitialized → Alive). value 는 초기값.
    log.t('🟢 [${_name(context)}] 생성됨 (didAddProvider)');
  }

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    // 상태가 갱신됨. 이전값 → 새값으로 무엇이 바뀌었는지 기록.
    log.d('🔄 [${_name(context)}] 갱신: $previousValue → $newValue');
  }

  @override
  void didDisposeProvider(ProviderObserverContext context) {
    // provider 가 폐기됨(Disposed). autoDispose 이거나 scope 가 사라질 때.
    log.i('⚪ [${_name(context)}] 폐기됨 (didDisposeProvider)');
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    // provider 초기화/비동기 작업이 에러를 던짐. 전역 에러 리포팅 지점.
    log.e('❌ [${_name(context)}] 실패: $error');
  }
}
