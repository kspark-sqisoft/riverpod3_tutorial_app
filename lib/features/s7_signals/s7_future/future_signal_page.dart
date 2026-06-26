import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../api/models/post.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../shared/async_state_view.dart';
import '../shared/signals_deps.dart';

// futureSignal: 비동기 작업 결과를 AsyncState<T> 로 노출한다(Riverpod FutureProvider 대응).
final _posts = futureSignal(() => signalsClient.fetchPosts(limit: 10));

/// 토픽 28: FutureSignal — 비동기 데이터. (Riverpod FutureProvider 대응)
class FutureSignalPage extends StatelessWidget {
  const FutureSignalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '28. FutureSignal (비동기)',
      explanation:
          'futureSignal(() async => ...) 은 Future 결과를 AsyncState 로 감싸 loading/error/data 를 '
          '관리합니다. Riverpod 의 FutureProvider + AsyncValue 에 대응합니다. UI 에서는 '
          '.value(=AsyncState)를 Watch 로 구독하고, .reload() 로 다시 불러옵니다.',
      points: const [
        'futureSignal: Future → AsyncState (loading/error/data)',
        '.value 가 AsyncState, Watch 로 구독',
        '.reload(): 처음부터 다시 / .refresh(): 이전 데이터 유지하며 갱신',
        'Riverpod FutureProvider + AsyncValue 에 대응',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                      padding: EdgeInsets.all(8), child: Text('dummyjson /posts')),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () => _posts.reload(), // 다시 불러오기
                    icon: const Icon(Icons.refresh),
                    label: const Text('새로고침'),
                  ),
                ],
              ),
              // Watch: _posts.value(AsyncState) 변화 구독
              SignalBuilder(builder:(context) => AsyncStateView<List<Post>>(
                    state: _posts.value,
                    onRetry: () => _posts.reload(),
                    data: (posts) => Column(
                      children: [
                        for (final post in posts)
                          ListTile(
                            dense: true,
                            leading: CircleAvatar(child: Text('${post.id}')),
                            title: Text(post.title,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'signals', code: _signalsCode),
        CodeSnippet(title: 'Riverpod (대응)', code: _riverpodCode),
      ],
    );
  }
}

const String _signalsCode = r'''
final posts = futureSignal(() => client.fetchPosts(limit: 10));

SignalBuilder(builder:(context) => posts.value.map(       // AsyncState
  data: (list) => /* 목록 */,
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => Text('에러: $e'),
));
posts.reload();                            // 다시 불러오기
''';

const String _riverpodCode = r'''
@riverpod
Future<List<Post>> postsList(Ref ref) =>
    ref.watch(dummyJsonClientProvider).fetchPosts(limit: 10);

final async = ref.watch(postsListProvider); // AsyncValue
ref.invalidate(postsListProvider);          // 다시 불러오기
''';
