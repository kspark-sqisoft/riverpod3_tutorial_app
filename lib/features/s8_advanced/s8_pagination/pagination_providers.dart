import 'package:riverpod_annotation/riverpod_annotation.dart'; // @riverpod, AsyncData 등 re-export

import '../../../api/api_providers.dart';
import '../../../api/models/post.dart';
import '../../../shared/app_logger.dart';

part 'pagination_providers.g.dart';

/// 페이지네이션(무한 스크롤): AsyncNotifier 가 누적 목록을 상태로 들고,
/// loadMore() 로 다음 페이지를 받아 뒤에 이어 붙인다.
@riverpod
class PostFeed extends _$PostFeed {
  static const int _pageSize = 10;
  bool _loading = false; // 중복 요청 방지
  bool _reachedEnd = false; // 마지막 페이지 도달

  bool get reachedEnd => _reachedEnd;

  @override
  Future<List<Post>> build() async {
    final client = ref.watch(dummyJsonClientProvider);
    _reachedEnd = false;
    return client.fetchPosts(limit: _pageSize, skip: 0); // 첫 페이지
  }

  /// 다음 페이지를 로드해 기존 목록 뒤에 이어 붙인다.
  Future<void> loadMore() async {
    if (_loading || _reachedEnd) return; // 가드: 동시/끝 요청 방지
    final current = state.value ?? const <Post>[];
    _loading = true;
    log.t('📄 다음 페이지 로드 (skip=${current.length})');
    final client = ref.read(dummyJsonClientProvider);
    final next = await client.fetchPosts(limit: _pageSize, skip: current.length);
    if (next.isEmpty) {
      _reachedEnd = true; // 더 없음
      log.i('📄 마지막 페이지 도달');
    } else {
      state = AsyncData([...current, ...next]); // 누적
    }
    _loading = false;
  }
}
