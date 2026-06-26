// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retry_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 일시적으로 실패하는 비동기 provider.
///
/// Riverpod 3 은 실패한 provider 를 지수 백오프(200ms→…)로 "자동 재시도"한다.
/// 별도 코드 없이도 시도 #1, #2 가 실패하면 잠시 후 자동으로 #3 을 시도해 성공한다.
/// (로그에서 자동 재시도 흐름을 확인하세요.)

@ProviderFor(autoRetryDemo)
final autoRetryDemoProvider = AutoRetryDemoProvider._();

/// 일시적으로 실패하는 비동기 provider.
///
/// Riverpod 3 은 실패한 provider 를 지수 백오프(200ms→…)로 "자동 재시도"한다.
/// 별도 코드 없이도 시도 #1, #2 가 실패하면 잠시 후 자동으로 #3 을 시도해 성공한다.
/// (로그에서 자동 재시도 흐름을 확인하세요.)

final class AutoRetryDemoProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// 일시적으로 실패하는 비동기 provider.
  ///
  /// Riverpod 3 은 실패한 provider 를 지수 백오프(200ms→…)로 "자동 재시도"한다.
  /// 별도 코드 없이도 시도 #1, #2 가 실패하면 잠시 후 자동으로 #3 을 시도해 성공한다.
  /// (로그에서 자동 재시도 흐름을 확인하세요.)
  AutoRetryDemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoRetryDemoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoRetryDemoHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return autoRetryDemo(ref);
  }
}

String _$autoRetryDemoHash() => r'342523a21f07daeffd6dd8a34b69d40cb4361d48';
