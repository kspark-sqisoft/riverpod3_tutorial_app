// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scoping_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 스코프 전용 provider.
///
/// 기본 구현은 예외를 던지고, 실제 값은 ProviderScope(overrides:) 로 "서브트리마다" 주입한다.
/// 리스트 아이템처럼 같은 위젯을 여러 번 쓰되 각자 다른 값을 흘려보내고 싶을 때 유용하다.
/// (코드생성에서 스코프 의존성을 명시하려면 @Riverpod(dependencies: [...]) 를 사용한다.)

@ProviderFor(currentItem)
final currentItemProvider = CurrentItemProvider._();

/// 스코프 전용 provider.
///
/// 기본 구현은 예외를 던지고, 실제 값은 ProviderScope(overrides:) 로 "서브트리마다" 주입한다.
/// 리스트 아이템처럼 같은 위젯을 여러 번 쓰되 각자 다른 값을 흘려보내고 싶을 때 유용하다.
/// (코드생성에서 스코프 의존성을 명시하려면 @Riverpod(dependencies: [...]) 를 사용한다.)

final class CurrentItemProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 스코프 전용 provider.
  ///
  /// 기본 구현은 예외를 던지고, 실제 값은 ProviderScope(overrides:) 로 "서브트리마다" 주입한다.
  /// 리스트 아이템처럼 같은 위젯을 여러 번 쓰되 각자 다른 값을 흘려보내고 싶을 때 유용하다.
  /// (코드생성에서 스코프 의존성을 명시하려면 @Riverpod(dependencies: [...]) 를 사용한다.)
  CurrentItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentItemHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return currentItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$currentItemHash() => r'0dc5ccfbeb26a2a1a2a596fc1c989d4403c1b47d';
