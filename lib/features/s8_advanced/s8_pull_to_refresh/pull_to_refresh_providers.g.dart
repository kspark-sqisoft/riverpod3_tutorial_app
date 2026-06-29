// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pull_to_refresh_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 당겨서 새로고침 대상이 되는 게시글 목록 provider.
///
/// RefreshIndicator 의 onRefresh 에서 `ref.refresh(refreshablePostsProvider.future)` 를
/// "반환"하면, 그 Future 가 끝날 때(= 이 build 가 다시 완료될 때)까지 스피너가 유지된다.
/// 화면은 async.value(이전 스냅샷)로 그리므로 새로고침 중에도 목록이 사라지지 않는다(깜빡임 없음).

@ProviderFor(refreshablePosts)
final refreshablePostsProvider = RefreshablePostsProvider._();

/// 당겨서 새로고침 대상이 되는 게시글 목록 provider.
///
/// RefreshIndicator 의 onRefresh 에서 `ref.refresh(refreshablePostsProvider.future)` 를
/// "반환"하면, 그 Future 가 끝날 때(= 이 build 가 다시 완료될 때)까지 스피너가 유지된다.
/// 화면은 async.value(이전 스냅샷)로 그리므로 새로고침 중에도 목록이 사라지지 않는다(깜빡임 없음).

final class RefreshablePostsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PostsSnapshot>,
          PostsSnapshot,
          FutureOr<PostsSnapshot>
        >
    with $FutureModifier<PostsSnapshot>, $FutureProvider<PostsSnapshot> {
  /// 당겨서 새로고침 대상이 되는 게시글 목록 provider.
  ///
  /// RefreshIndicator 의 onRefresh 에서 `ref.refresh(refreshablePostsProvider.future)` 를
  /// "반환"하면, 그 Future 가 끝날 때(= 이 build 가 다시 완료될 때)까지 스피너가 유지된다.
  /// 화면은 async.value(이전 스냅샷)로 그리므로 새로고침 중에도 목록이 사라지지 않는다(깜빡임 없음).
  RefreshablePostsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refreshablePostsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refreshablePostsHash();

  @$internal
  @override
  $FutureProviderElement<PostsSnapshot> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PostsSnapshot> create(Ref ref) {
    return refreshablePosts(ref);
  }
}

String _$refreshablePostsHash() => r'05c70771c36b3163793cccc110cc7cbf1e9de327';
