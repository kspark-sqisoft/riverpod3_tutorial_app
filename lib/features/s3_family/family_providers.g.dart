// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'family_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// family: 파라미터를 받는 provider.
///
/// 코드생성에서는 family 모디파이어 없이 그냥 "함수 인자"를 추가하면 된다.
/// id 마다 별도의 provider 인스턴스가 만들어지고 각각 따로 캐시된다.
/// (postByIdProvider(1), postByIdProvider(2) 는 서로 다른 상태)

@ProviderFor(postById)
final postByIdProvider = PostByIdFamily._();

/// family: 파라미터를 받는 provider.
///
/// 코드생성에서는 family 모디파이어 없이 그냥 "함수 인자"를 추가하면 된다.
/// id 마다 별도의 provider 인스턴스가 만들어지고 각각 따로 캐시된다.
/// (postByIdProvider(1), postByIdProvider(2) 는 서로 다른 상태)

final class PostByIdProvider
    extends $FunctionalProvider<AsyncValue<Post>, Post, FutureOr<Post>>
    with $FutureModifier<Post>, $FutureProvider<Post> {
  /// family: 파라미터를 받는 provider.
  ///
  /// 코드생성에서는 family 모디파이어 없이 그냥 "함수 인자"를 추가하면 된다.
  /// id 마다 별도의 provider 인스턴스가 만들어지고 각각 따로 캐시된다.
  /// (postByIdProvider(1), postByIdProvider(2) 는 서로 다른 상태)
  PostByIdProvider._({
    required PostByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'postByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postByIdHash();

  @override
  String toString() {
    return r'postByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Post> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Post> create(Ref ref) {
    final argument = this.argument as int;
    return postById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PostByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postByIdHash() => r'56af8534d69077947707e2206e0d55c3cba43e29';

/// family: 파라미터를 받는 provider.
///
/// 코드생성에서는 family 모디파이어 없이 그냥 "함수 인자"를 추가하면 된다.
/// id 마다 별도의 provider 인스턴스가 만들어지고 각각 따로 캐시된다.
/// (postByIdProvider(1), postByIdProvider(2) 는 서로 다른 상태)

final class PostByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Post>, int> {
  PostByIdFamily._()
    : super(
        retry: null,
        name: r'postByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// family: 파라미터를 받는 provider.
  ///
  /// 코드생성에서는 family 모디파이어 없이 그냥 "함수 인자"를 추가하면 된다.
  /// id 마다 별도의 provider 인스턴스가 만들어지고 각각 따로 캐시된다.
  /// (postByIdProvider(1), postByIdProvider(2) 는 서로 다른 상태)

  PostByIdProvider call(int id) => PostByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'postByIdProvider';
}
