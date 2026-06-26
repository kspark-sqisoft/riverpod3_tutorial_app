import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stream_providers.g.dart';

/// StreamProvider(함수형): 1초마다 1씩 증가하는 정수 스트림.
///
/// async* 제너레이터로 값을 계속 yield 한다. 구독자가 사라지면(autoDispose)
/// Riverpod 이 스트림 구독을 자동으로 취소하므로 메모리 누수가 없다.
@riverpod
Stream<int> ticker(Ref ref) async* {
  var count = 0;
  while (true) {
    yield count; // 현재 값 방출 → 구독 위젯에 AsyncData 로 전달
    count++;
    await Future<void>.delayed(const Duration(seconds: 1)); // 1초 대기
  }
}

/// StreamNotifier(클래스형): 스트림 + 메서드를 함께 갖고 싶을 때 사용.
/// 여기서는 build 가 0부터 1초 간격으로 증가하는 스트림을 반환한다.
@riverpod
class Stopwatch extends _$Stopwatch {
  @override
  Stream<int> build() async* {
    var seconds = 0;
    while (true) {
      yield seconds;
      seconds++;
      await Future<void>.delayed(const Duration(seconds: 1));
    }
  }
}
