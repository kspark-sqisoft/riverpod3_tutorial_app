import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models/post.dart';
import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'debounce_providers.dart';

/// 토픽 22: 비동기 합성 · 취소 · 디바운스.
class DebouncePage extends ConsumerWidget {
  const DebouncePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);

    return ConceptPage(
      title: '22. 비동기 합성 · 취소 · 디바운스',
      explanation:
          '검색어가 바뀔 때마다 검색 provider 가 재실행되는데, 400ms 대기를 넣어 빠른 타이핑 '
          '중에는 마지막 입력만 실제 요청되게 합니다(디바운스). 재실행 시 이전 build 는 폐기되어 '
          'onDispose 가 호출되므로, 거기서 진행 중 요청/타이머를 취소할 수 있습니다. 아래 검색창에 '
          '빠르게 입력하며 로그의 "취소"와 "검색 실행"을 확인하세요.',
      points: const [
        '디바운스: ref.watch + await delay 로 마지막 입력만 통과',
        'onDispose: 재입력/이탈 시 이전 요청 취소 지점',
        '비동기 합성: await ref.watch(otherProvider.future) 로 여러 결과 결합',
        '실제 네트워크 취소는 CancelToken(dio) 등으로 확장',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: '게시글 검색(빠르게 타이핑해 보세요)',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    // 입력마다 검색어 상태 갱신 → searchResults 재실행(디바운스)
                    onChanged: (q) =>
                        ref.read(searchQueryProvider.notifier).setQuery(q),
                  ),
                  const SizedBox(height: 8),
                  AsyncValueView<List<Post>>(
                    value: resultsAsync,
                    data: (posts) => posts.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: Text('검색어를 입력하세요'))
                        : Column(
                            children: [
                              for (final p in posts.take(6))
                                ListTile(
                                  dense: true,
                                  title: Text(p.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 180),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'debounce_providers.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
@riverpod
Future<List<Post>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider).trim();
  if (query.isEmpty) return const [];
  ref.onDispose(() => cancelInFlight()); // 재입력/이탈 시 취소
  await Future.delayed(const Duration(milliseconds: 400)); // 디바운스
  return ref.read(dummyJsonClientProvider).searchPosts(query);
}

// 비동기 합성 예: 여러 provider 결과를 await 로 결합
// final a = await ref.watch(aProvider.future);
// final b = await ref.watch(bProvider.future);
''';
