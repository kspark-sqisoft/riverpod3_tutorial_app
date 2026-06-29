import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/post.dart';
import '../../../shared/async_value_view.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';
import 'cancel_providers.dart';

/// 토픽 40: 요청 취소 (http.Client.close vs dio.CancelToken) — 둘 다 라이브.
class CancelPage extends ConsumerWidget {
  const CancelPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final httpAsync = ref.watch(cancellableSearchProvider); // ① http 버전
    final dioAsync = ref.watch(cancellableSearchDioProvider); // ② dio 버전
    final query = ref.watch(cancelQueryProvider);

    return ConceptPage(
      title: '40. 요청 취소 (cancel — http · dio)',
      explanation:
          '진행 중인 비동기 요청을 "실제로" 멈추는 방법을 http·dio 두 클라이언트로 나란히 보여줍니다. '
          '검색창에 입력하면 두 provider 가 함께 재실행되고, 이전 build 는 폐기되며 onDispose 가 호출됩니다. '
          '① http: build 전용 http.Client 를 만들어 onDispose 에서 client.close() 로 끊습니다(+ didDispose '
          '플래그로 "보내기 전" 요청은 생략). ② dio: 요청에 CancelToken 을 연결하고 onDispose 에서 '
          'cancelToken.cancel() 로 끊습니다(riverpod 공식 pub 예제 detail.dart 방식). dio 의 CancelToken 은 '
          '"보내기 전/보낸 뒤"를 한 번에 처리해서, 이미 취소된 토큰으로 요청하면 즉시 DioException(type: cancel) '
          '을 던집니다. 빠르게 타이핑하거나 "지우기"로 이탈시키며 로그를 보세요 — 섞이면 상단 "① http / ② dio" '
          '칩으로 한쪽만 골라 볼 수 있습니다. (이 화면을 떠나도 autoDispose 라 두 요청 모두 취소됩니다.)',
      points: const [
        'onDispose: 재입력/이탈 시 호출 — 취소 로직을 거는 자리',
        '① http: ref.onDispose(client.close) + didDispose 플래그("보내기 전" 생략)',
        '② dio: CancelToken + ref.onDispose(cancelToken.cancel) + dio.get(cancelToken:)',
        'dio 의 CancelToken 은 "보내기 전/보낸 뒤"를 한 번에 처리(이미 취소면 즉시 throw)',
        '입력 변경 = 이전 build 폐기(취소) + 새 build → 마지막 입력만 통과',
        'autoDispose: 화면 이탈 시에도 자동 폐기 → 요청 취소',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 검색 입력 — http·dio 두 provider 가 공유한다.
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: '게시글 검색(빠르게 타이핑 → 이전 요청 취소)',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    // 입력마다 검색어 갱신 → 두 provider 재실행(이전 요청 취소)
                    onChanged: (q) =>
                        ref.read(cancelQueryProvider.notifier).setQuery(q),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          query.trim().isEmpty
                              ? '검색어를 입력하세요'
                              : '현재 검색어: "$query"',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      // 검색어를 비워 진행 중 요청을 폐기(취소)시킨다.
                      OutlinedButton.icon(
                        onPressed: () =>
                            ref.read(cancelQueryProvider.notifier).setQuery(''),
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text('지우기(취소)'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _ResultCard(
            title: '① http — Client.close()',
            icon: Icons.http,
            value: httpAsync,
          ),
          const SizedBox(height: 12),
          _ResultCard(
            title: '② dio — CancelToken',
            icon: Icons.cancel_schedule_send,
            value: dioAsync,
          ),
          const SizedBox(height: 12),
          // 두 provider 로그가 섞이므로 출처 칩으로 한쪽만 골라 본다.
          LifecycleLogView(
            height: 220,
            filters: [
              LogFilter(
                label: '① http',
                test: (e) => e.message.contains('[cancellableSearchProvider]'),
              ),
              LogFilter(
                label: '② dio',
                test: (e) =>
                    e.message.contains('[cancellableSearchDioProvider]'),
              ),
            ],
          ),
        ],
      ),
      snippets: const [
        CodeSnippet(
            title: 'cancel_providers.dart — ① http (Client.close)', code: _codeHttp),
        CodeSnippet(
            title: 'cancel_providers.dart — ② dio (CancelToken)', code: _codeDio),
      ],
    );
  }
}

/// http/dio 결과를 같은 모양으로 그리는 작은 카드.
class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.title,
    required this.icon,
    required this.value,
  });

  final String title;
  final IconData icon;
  final AsyncValue<List<Post>> value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 6),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ],
            ),
            const Divider(),
            AsyncValueView<List<Post>>(
              value: value,
              data: (posts) => posts.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text('결과 없음 / 검색어를 입력하세요'),
                    )
                  : Column(
                      children: [
                        for (final p in posts.take(5))
                          ListTile(
                            dense: true,
                            leading: CircleAvatar(child: Text('${p.id}')),
                            title: Text(p.title,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _codeHttp = r'''
@riverpod
Future<List<Post>> cancellableSearch(Ref ref) async {
  final query = ref.watch(cancelQueryProvider).trim();
  if (query.isEmpty) return const [];

  // 이 build 전용 client — 폐기되면 close() 로 진행 중 요청을 끊는다.
  final client = http.Client();
  var didDispose = false;
  ref.onDispose(() {
    didDispose = true;
    client.close();          // ② 보낸 뒤: 진행 중 HTTP 요청을 실제로 취소
  });

  await Future.delayed(const Duration(milliseconds: 450)); // 디바운스
  if (didDispose) throw Exception('취소됨'); // ① 보내기 전: 요청 생략

  final res = await client.get(Uri.parse(
      'https://dummyjson.com/posts/search?q=$query'));
  return parsePosts(res.body);
}
''';

const String _codeDio = r'''
final _dio = Dio(); // 공유 인스턴스 (CancelToken 은 요청마다 따로)

@riverpod
Future<List<Post>> cancellableSearchDio(Ref ref) async {
  final query = ref.watch(cancelQueryProvider).trim();
  if (query.isEmpty) return const [];

  // 요청 취소용 토큰 — 폐기되면 cancel() 로 진행 중 요청을 끊는다.
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel('취소'));

  await Future.delayed(const Duration(milliseconds: 450)); // 디바운스
  // 이미 취소됐다면 dio.get 이 곧바로 DioException(type: cancel) 을 던진다(요청 생략).

  final res = await _dio.get<Map<String, dynamic>>(
    'https://dummyjson.com/posts/search',
    queryParameters: {'q': query, 'limit': 10},
    cancelToken: cancelToken, // 이 요청에 취소 토큰 연결
  );
  return (res.data!['posts'] as List)
      .cast<Map<String, dynamic>>()
      .map(Post.fromJson)
      .toList();
}
''';
