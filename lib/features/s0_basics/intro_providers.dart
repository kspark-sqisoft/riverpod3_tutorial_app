import 'package:riverpod_annotation/riverpod_annotation.dart';

// 코드생성 결과물(빌드 후 생성됨). `dart run build_runner build` 필요.
part 'intro_providers.g.dart';

/// 가장 단순한 provider: 읽기 전용 값을 제공하는 "함수형 provider".
///
/// @riverpod 를 붙이면 코드생성이 `greetingProvider` 를 만들어 준다.
/// 인자로 받는 [Ref] 는 다른 provider 를 읽거나 라이프사이클 콜백을 등록하는 손잡이다.
@riverpod
String greeting(Ref ref) {
  return '안녕하세요, Riverpod 3! 👋'; // 이 값을 ref.watch(greetingProvider) 로 구독
}

/// 상태를 가진 가장 기본적인 provider: NotifierProvider(코드생성 클래스형).
///
/// build() 가 초기 상태를 반환하고, 메서드에서 state 를 바꾸면 구독자가 자동 갱신된다.
/// (NotifierProvider 자세한 내용은 토픽 3에서 깊이 다룬다 — 여기선 watch/read 비교용.)
@riverpod
class IntroCounter extends _$IntroCounter {
  @override
  int build() => 0; // 초기 상태: 0

  void increment() => state++; // 상태 증가 → 구독 위젯만 다시 그려짐
}
