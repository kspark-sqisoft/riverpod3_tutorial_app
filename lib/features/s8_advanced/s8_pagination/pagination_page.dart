import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/post.dart';
import '../../../shared/async_value_view.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import 'pagination_providers.dart';

/// 토픽 35: 페이지네이션 / 무한 스크롤.
class PaginationPage extends ConsumerStatefulWidget {
  const PaginationPage({super.key});

  @override
  ConsumerState<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends ConsumerState<PaginationPage> {
  final _scroll = ScrollController();
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll); // 스크롤 끝 근처에서 다음 페이지 로드
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final nearBottom =
        _scroll.position.pixels >= _scroll.position.maxScrollExtent - 120;
    if (nearBottom) _loadMore();
  }

  Future<void> _loadMore() async {
    if (_loadingMore) return;
    setState(() => _loadingMore = true);
    await ref.read(postFeedProvider.notifier).loadMore();
    if (mounted) setState(() => _loadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(postFeedProvider);
    final reachedEnd = ref.read(postFeedProvider.notifier).reachedEnd;

    return ConceptPage(
      title: '35. 페이지네이션 / 무한 스크롤',
      explanation:
          'AsyncNotifier 가 "누적 목록"을 상태로 들고, 스크롤이 끝에 가까워지면 loadMore() 로 '
          '다음 페이지(dummyjson skip/limit)를 받아 뒤에 이어 붙입니다. 중복 요청과 마지막 페이지를 '
          '플래그로 막습니다. 목록을 끝까지 스크롤하면 자동으로 다음 페이지가 로드됩니다.',
      points: const [
        'AsyncNotifier 상태 = 지금까지 쌓인 전체 목록',
        'loadMore(): skip = 현재 길이, 결과를 [...current, ...next] 로 누적',
        '_loading/_reachedEnd 플래그로 중복·끝 요청 방지',
        'ScrollController 로 끝 근처 감지 → 자동 로드',
      ],
      demo: SizedBox(
        height: 380,
        child: Card(
          child: AsyncValueView<List<Post>>(
            value: async,
            onRetry: () => ref.invalidate(postFeedProvider),
            data: (posts) => ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(8),
              itemCount: posts.length + 1, // +1 = 푸터
              itemBuilder: (context, index) {
                if (index < posts.length) {
                  final post = posts[index];
                  return ListTile(
                    dense: true,
                    leading: CircleAvatar(child: Text('${post.id}')),
                    title: Text(post.title,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  );
                }
                // 푸터: 로딩 스피너 / 끝 안내
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Center(
                    child: reachedEnd
                        ? const Text('— 마지막입니다 —')
                        : _loadingMore
                            ? const CircularProgressIndicator()
                            : Text('스크롤하면 더 불러옵니다 (현재 ${posts.length}개)'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'pagination_providers.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
@riverpod
class PostFeed extends _$PostFeed {
  bool _loading = false, _reachedEnd = false;

  @override
  Future<List<Post>> build() =>
      ref.watch(dummyJsonClientProvider).fetchPosts(limit: 10, skip: 0);

  Future<void> loadMore() async {
    if (_loading || _reachedEnd) return;
    final current = state.value ?? const <Post>[];
    _loading = true;
    final next = await ref.read(dummyJsonClientProvider)
        .fetchPosts(limit: 10, skip: current.length);
    if (next.isEmpty) { _reachedEnd = true; }
    else { state = AsyncData([...current, ...next]); }
    _loading = false;
  }
}
''';
