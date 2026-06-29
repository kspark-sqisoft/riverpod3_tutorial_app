import 'package:flutter/gestures.dart'; // PointerDeviceKind
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';
import 'pull_to_refresh_providers.dart';

// 데스크톱/웹의 기본 ScrollBehavior 는 마우스를 dragDevices 에서 제외해, 마우스로 목록을
// 끌어 스크롤(→ 당겨서 새로고침)할 수 없다. mouse 를 추가해 마우스 드래그로도 동작하게 한다.
final _dragWithMouse = const MaterialScrollBehavior().copyWith(
  dragDevices: {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
    PointerDeviceKind.unknown,
  },
);

/// 토픽 39: 당겨서 새로고침 (RefreshIndicator + ref.refresh(provider.future)).
class PullToRefreshPage extends ConsumerWidget {
  const PullToRefreshPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(refreshablePostsProvider);
    final snapshot = async.value; // 이전 스냅샷 — 새로고침 중에도 유지(깜빡임 없음)

    return ConceptPage(
      title: '39. 당겨서 새로고침 (RefreshIndicator)',
      explanation:
          '목록을 아래로 당기면 RefreshIndicator 가 새로고침을 시작합니다. 핵심은 onRefresh 에서 '
          '`ref.refresh(provider.future)` 를 "반환"하는 것 — 반환된 Future 가 끝날 때(= 다시 build 완료)까지 '
          '인디케이터 스피너가 돕니다. 그리고 화면을 async.value(이전 데이터)로 그리면 새로고침 중에도 '
          '기존 목록이 사라지지 않아 깜빡임이 없습니다. 받아온 시각이 매번 바뀌는 것으로 실제 재요청을 확인하세요. '
          'RefreshIndicator 는 스크롤 가능한 위젯을 감싸야 하므로, 내용이 짧아도 당길 수 있도록 '
          'AlwaysScrollableScrollPhysics 를 줍니다. (데스크톱/웹에서는 마우스로 목록을 아래로 끌면 됩니다.)',
      points: const [
        'RefreshIndicator(onRefresh: ...) 로 스크롤 가능한 목록을 감싼다',
        'onRefresh: () => ref.refresh(provider.future) — Future 를 반환해야 완료까지 스피너 유지',
        '화면은 async.value(이전 데이터)로 그려 새로고침 중 목록 유지(깜빡임 없음)',
        'AlwaysScrollableScrollPhysics: 내용이 짧아도 당겨서 새로고침 가능',
        '최초 로딩(value == null)만 스피너, 그 외엔 목록 표시',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 재요청 중이면 상단에 가는 진행 바(목록은 그대로 유지된다).
          if (async.isLoading && snapshot != null)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(minHeight: 3),
            ),
          SizedBox(
            height: 380,
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: _buildBody(context, ref, async, snapshot),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 160),
        ],
      ),
      snippets: const [
        CodeSnippet(
          title: 'pull_to_refresh_page.dart (RefreshIndicator)',
          code: _codePage,
        ),
        CodeSnippet(
          title: 'pull_to_refresh_providers.dart',
          code: _codeProvider,
        ),
      ],
    );
  }

  // 본문: 최초 로딩 / 에러(데이터 없음) / 목록(이전 데이터 유지)을 구분해 그린다.
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<PostsSnapshot> async,
    PostsSnapshot? snapshot,
  ) {
    // 아직 한 번도 못 받은 상태(value == null).
    if (snapshot == null) {
      if (async.hasError) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 8),
                Text('에러: ${async.error}', textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => ref.invalidate(refreshablePostsProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    }

    final (posts, fetchedAt) = snapshot;
    // 마우스 드래그로도 당겨서 새로고침되도록 ScrollConfiguration 으로 감싼다(위 _dragWithMouse).
    return ScrollConfiguration(
      behavior: _dragWithMouse,
      child: RefreshIndicator(
        // onRefresh 가 반환하는 Future 가 끝날 때까지 스피너 유지 → ref.refresh(provider.future) 를 반환.
        onRefresh: () => ref.refresh(refreshablePostsProvider.future),
        child: ListView.builder(
          // 내용이 짧아도 당길 수 있도록 항상 스크롤 가능하게.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: posts.length + 1, // +1 = 머리말(받아온 시각)
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 12),
                child: Row(
                  children: [
                    const Icon(Icons.swipe_down, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '아래로 당겨 새로고침 · 받아온 시각 @$fetchedAt',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              );
            }
            final post = posts[index - 1];
            return ListTile(
              dense: true,
              leading: CircleAvatar(child: Text('${post.id}')),
              title: Text(
                post.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
        ),
      ),
    );
  }
}

const String _codePage = r'''
final async = ref.watch(refreshablePostsProvider);
final snapshot = async.value;            // 이전 데이터(새로고침 중에도 유지)

if (snapshot == null) return const CircularProgressIndicator(); // 최초 로딩

return RefreshIndicator(
  // 반환된 Future 가 끝날 때까지(= 다시 build 완료) 스피너 유지
  onRefresh: () => ref.refresh(refreshablePostsProvider.future),
  child: ListView.builder(
    physics: const AlwaysScrollableScrollPhysics(), // 짧아도 당길 수 있게
    itemCount: snapshot.$1.length,
    itemBuilder: (_, i) => ListTile(title: Text(snapshot.$1[i].title)),
  ),
);
''';

const String _codeProvider = r'''
typedef PostsSnapshot = (List<Post> posts, String fetchedAt);

@riverpod
Future<PostsSnapshot> refreshablePosts(Ref ref) async {
  final client = ref.watch(dummyJsonClientProvider);
  final posts = await client.fetchPosts(limit: 12);
  return (posts, nowHHmmss()); // 시각이 매번 바뀌어 재요청을 확인
}

// 사용처 — onRefresh 에서 .future 를 refresh 하고 그 Future 를 반환
onRefresh: () => ref.refresh(refreshablePostsProvider.future),
''';
