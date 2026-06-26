// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 페이지네이션(무한 스크롤): AsyncNotifier 가 누적 목록을 상태로 들고,
/// loadMore() 로 다음 페이지를 받아 뒤에 이어 붙인다.

@ProviderFor(PostFeed)
final postFeedProvider = PostFeedProvider._();

/// 페이지네이션(무한 스크롤): AsyncNotifier 가 누적 목록을 상태로 들고,
/// loadMore() 로 다음 페이지를 받아 뒤에 이어 붙인다.
final class PostFeedProvider
    extends $AsyncNotifierProvider<PostFeed, List<Post>> {
  /// 페이지네이션(무한 스크롤): AsyncNotifier 가 누적 목록을 상태로 들고,
  /// loadMore() 로 다음 페이지를 받아 뒤에 이어 붙인다.
  PostFeedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postFeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postFeedHash();

  @$internal
  @override
  PostFeed create() => PostFeed();
}

String _$postFeedHash() => r'8a6761ce6f10853976357564d5e23fd980b93efc';

/// 페이지네이션(무한 스크롤): AsyncNotifier 가 누적 목록을 상태로 들고,
/// loadMore() 로 다음 페이지를 받아 뒤에 이어 붙인다.

abstract class _$PostFeed extends $AsyncNotifier<List<Post>> {
  FutureOr<List<Post>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Post>>, List<Post>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Post>>, List<Post>>,
              AsyncValue<List<Post>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
