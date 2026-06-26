// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intro_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 가장 단순한 provider: 읽기 전용 값을 제공하는 "함수형 provider".
///
/// @riverpod 를 붙이면 코드생성이 `greetingProvider` 를 만들어 준다.
/// 인자로 받는 [Ref] 는 다른 provider 를 읽거나 라이프사이클 콜백을 등록하는 손잡이다.

@ProviderFor(greeting)
final greetingProvider = GreetingProvider._();

/// 가장 단순한 provider: 읽기 전용 값을 제공하는 "함수형 provider".
///
/// @riverpod 를 붙이면 코드생성이 `greetingProvider` 를 만들어 준다.
/// 인자로 받는 [Ref] 는 다른 provider 를 읽거나 라이프사이클 콜백을 등록하는 손잡이다.

final class GreetingProvider extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 가장 단순한 provider: 읽기 전용 값을 제공하는 "함수형 provider".
  ///
  /// @riverpod 를 붙이면 코드생성이 `greetingProvider` 를 만들어 준다.
  /// 인자로 받는 [Ref] 는 다른 provider 를 읽거나 라이프사이클 콜백을 등록하는 손잡이다.
  GreetingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'greetingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$greetingHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return greeting(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$greetingHash() => r'468d80a9596bbf0b252dc0b2130a71fa4899ebef';

/// 상태를 가진 가장 기본적인 provider: NotifierProvider(코드생성 클래스형).
///
/// build() 가 초기 상태를 반환하고, 메서드에서 state 를 바꾸면 구독자가 자동 갱신된다.
/// (NotifierProvider 자세한 내용은 토픽 3에서 깊이 다룬다 — 여기선 watch/read 비교용.)

@ProviderFor(IntroCounter)
final introCounterProvider = IntroCounterProvider._();

/// 상태를 가진 가장 기본적인 provider: NotifierProvider(코드생성 클래스형).
///
/// build() 가 초기 상태를 반환하고, 메서드에서 state 를 바꾸면 구독자가 자동 갱신된다.
/// (NotifierProvider 자세한 내용은 토픽 3에서 깊이 다룬다 — 여기선 watch/read 비교용.)
final class IntroCounterProvider extends $NotifierProvider<IntroCounter, int> {
  /// 상태를 가진 가장 기본적인 provider: NotifierProvider(코드생성 클래스형).
  ///
  /// build() 가 초기 상태를 반환하고, 메서드에서 state 를 바꾸면 구독자가 자동 갱신된다.
  /// (NotifierProvider 자세한 내용은 토픽 3에서 깊이 다룬다 — 여기선 watch/read 비교용.)
  IntroCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'introCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$introCounterHash();

  @$internal
  @override
  IntroCounter create() => IntroCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$introCounterHash() => r'a37928f698ee87e39b78a624d433ff14429bce7f';

/// 상태를 가진 가장 기본적인 provider: NotifierProvider(코드생성 클래스형).
///
/// build() 가 초기 상태를 반환하고, 메서드에서 state 를 바꾸면 구독자가 자동 갱신된다.
/// (NotifierProvider 자세한 내용은 토픽 3에서 깊이 다룬다 — 여기선 watch/read 비교용.)

abstract class _$IntroCounter extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
