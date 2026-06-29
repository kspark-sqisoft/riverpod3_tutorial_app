import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/api_providers.dart';
import '../../../api/models/post.dart';
import '../../../shared/app_logger.dart';

part 'pull_to_refresh_providers.g.dart';

/// 새로고침마다 갱신되는 (게시글 목록 + 받아온 시각).
/// 시각이 매번 바뀌는 것으로 "실제로 다시 받아왔다"를 눈으로 확인한다.
typedef PostsSnapshot = (List<Post> posts, String fetchedAt);

// 외부 패키지 없이 HH:mm:ss 시각 문자열.
String _nowHms() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// 당겨서 새로고침 대상이 되는 게시글 목록 provider.
///
/// RefreshIndicator 의 onRefresh 에서 `ref.refresh(refreshablePostsProvider.future)` 를
/// "반환"하면, 그 Future 가 끝날 때(= 이 build 가 다시 완료될 때)까지 스피너가 유지된다.
/// 화면은 async.value(이전 스냅샷)로 그리므로 새로고침 중에도 목록이 사라지지 않는다(깜빡임 없음).
@riverpod
Future<PostsSnapshot> refreshablePosts(Ref ref) async {
  final client = ref.watch(dummyJsonClientProvider);
  log.t('🔄 [refreshablePostsProvider] build — 게시글 다시 로드');
  final posts = await client.fetchPosts(limit: 12);
  final at = _nowHms();
  log.i('🔄 [refreshablePostsProvider] 로드 완료: ${posts.length}건 @$at');
  return (posts, at);
}
