// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'future_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// FutureProvider(코드생성 함수형): 비동기로 게시글 목록을 가져온다.
///
/// 반환 타입이 `Future<T>` 이면 Riverpod 이 자동으로 `AsyncValue<T>` 로 감싸
/// loading/error/data 상태를 관리해 준다. 우리는 Future 만 돌려주면 된다.

@ProviderFor(postsList)
final postsListProvider = PostsListProvider._();

/// FutureProvider(코드생성 함수형): 비동기로 게시글 목록을 가져온다.
///
/// 반환 타입이 `Future<T>` 이면 Riverpod 이 자동으로 `AsyncValue<T>` 로 감싸
/// loading/error/data 상태를 관리해 준다. 우리는 Future 만 돌려주면 된다.

final class PostsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>
        >
    with $FutureModifier<List<Post>>, $FutureProvider<List<Post>> {
  /// FutureProvider(코드생성 함수형): 비동기로 게시글 목록을 가져온다.
  ///
  /// 반환 타입이 `Future<T>` 이면 Riverpod 이 자동으로 `AsyncValue<T>` 로 감싸
  /// loading/error/data 상태를 관리해 준다. 우리는 Future 만 돌려주면 된다.
  PostsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsListHash();

  @$internal
  @override
  $FutureProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Post>> create(Ref ref) {
    return postsList(ref);
  }
}

String _$postsListHash() => r'cd24f802468e15f17eb37a4eb41cc0f312fbf6d1';
