import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/api_providers.dart';
import '../../api/models/post.dart';
import '../../shared/app_logger.dart';

part 'debounce_providers.g.dart';

/// 검색어 상태.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}

/// 디바운스 검색 결과.
///
/// 동작 원리:
///  - searchQuery 를 watch → 입력이 바뀔 때마다 이 build 가 재실행된다.
///  - 재실행 시 이전 build 는 폐기되어 onDispose 가 호출된다(취소 지점).
///  - 400ms 대기 후 실제 검색 → 빠르게 타이핑하면 마지막 입력만 통과(디바운스).
@riverpod
Future<List<Post>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return const [];

  // 이전 요청 취소 지점(실제 네트워크 취소는 dio CancelToken 등으로 확장 가능)
  ref.onDispose(() => log.w('🚫 검색 취소: "$query" (재입력/이탈)'));

  log.t('⏳ 디바운스 대기(400ms): "$query"');
  await Future<void>.delayed(const Duration(milliseconds: 400)); // 디바운스
  log.i('🔎 검색 실행: "$query"');

  final client = ref.read(dummyJsonClientProvider);
  return client.searchPosts(query);
}
