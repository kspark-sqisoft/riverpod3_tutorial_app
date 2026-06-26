// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// StreamProvider(함수형): 1초마다 1씩 증가하는 정수 스트림.
///
/// async* 제너레이터로 값을 계속 yield 한다. 구독자가 사라지면(autoDispose)
/// Riverpod 이 스트림 구독을 자동으로 취소하므로 메모리 누수가 없다.

@ProviderFor(ticker)
final tickerProvider = TickerProvider._();

/// StreamProvider(함수형): 1초마다 1씩 증가하는 정수 스트림.
///
/// async* 제너레이터로 값을 계속 yield 한다. 구독자가 사라지면(autoDispose)
/// Riverpod 이 스트림 구독을 자동으로 취소하므로 메모리 누수가 없다.

final class TickerProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// StreamProvider(함수형): 1초마다 1씩 증가하는 정수 스트림.
  ///
  /// async* 제너레이터로 값을 계속 yield 한다. 구독자가 사라지면(autoDispose)
  /// Riverpod 이 스트림 구독을 자동으로 취소하므로 메모리 누수가 없다.
  TickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tickerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tickerHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return ticker(ref);
  }
}

String _$tickerHash() => r'dab8c9775c6972261385a829e96620fc49238bc6';

/// StreamNotifier(클래스형): 스트림 + 메서드를 함께 갖고 싶을 때 사용.
/// 여기서는 build 가 0부터 1초 간격으로 증가하는 스트림을 반환한다.

@ProviderFor(Stopwatch)
final stopwatchProvider = StopwatchProvider._();

/// StreamNotifier(클래스형): 스트림 + 메서드를 함께 갖고 싶을 때 사용.
/// 여기서는 build 가 0부터 1초 간격으로 증가하는 스트림을 반환한다.
final class StopwatchProvider extends $StreamNotifierProvider<Stopwatch, int> {
  /// StreamNotifier(클래스형): 스트림 + 메서드를 함께 갖고 싶을 때 사용.
  /// 여기서는 build 가 0부터 1초 간격으로 증가하는 스트림을 반환한다.
  StopwatchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stopwatchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stopwatchHash();

  @$internal
  @override
  Stopwatch create() => Stopwatch();
}

String _$stopwatchHash() => r'c3f7f7c024661255d464187f2bbe91d4345d8f22';

/// StreamNotifier(클래스형): 스트림 + 메서드를 함께 갖고 싶을 때 사용.
/// 여기서는 build 가 0부터 1초 간격으로 증가하는 스트림을 반환한다.

abstract class _$Stopwatch extends $StreamNotifier<int> {
  Stream<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
