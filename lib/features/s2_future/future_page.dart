import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models/post.dart';
import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'future_providers.dart';

/// 토픽 5: FutureProvider & AsyncValue — 비동기 데이터를 화면에 안전하게 표시.
class FuturePage extends ConsumerWidget {
  const FuturePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // postsListProvider 는 AsyncValue<List<Post>> 를 노출한다.
    final postsAsync = ref.watch(postsListProvider);

    return ConceptPage(
      title: '5. FutureProvider & AsyncValue',
      explanation:
          '비동기 함수를 반환하는 provider 는 결과를 AsyncValue 로 감쌉니다. AsyncValue 는 '
          'loading/error/data 세 상태를 한 타입으로 표현하므로, .when() 으로 분기하면 '
          '로딩 스피너·에러 화면·데이터 화면을 누락 없이 처리할 수 있습니다. '
          '새로고침은 ref.invalidate 로 provider 를 무효화해 다시 불러옵니다.',
      points: const [
        'Future<T> 반환 → 자동으로 AsyncValue<T> 로 래핑',
        'AsyncValue.when(data/loading/error): 세 상태를 강제로 모두 처리',
        'ref.invalidate(provider): 캐시 무효화 → 재요청(새로고침)',
        '에러는 throw 만 하면 AsyncError 로 잡혀 error 콜백으로 전달됨',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('dummyjson /posts'),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    // 새로고침: provider 를 무효화하면 build 가 다시 실행됨
                    onPressed: () => ref.invalidate(postsListProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('새로고침'),
                  ),
                ],
              ),
              // AsyncValue 를 data/loading/error 로 렌더(공유 헬퍼)
              AsyncValueView<List<Post>>(
                value: postsAsync,
                onRetry: () => ref.invalidate(postsListProvider),
                data: (posts) => Column(
                  children: [
                    for (final post in posts)
                      ListTile(
                        dense: true,
                        leading: CircleAvatar(child: Text('${post.id}')),
                        title: Text(post.title,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(post.body,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'future_providers.dart', code: _providerCode),
        CodeSnippet(title: 'future_page.dart (사용부)', code: _usageCode),
      ],
    );
  }
}

const String _providerCode = r'''
@riverpod
Future<List<Post>> postsList(Ref ref) {
  final client = ref.watch(dummyJsonClientProvider);
  return client.fetchPosts(limit: 10); // Future → AsyncValue 자동 변환
}
''';

const String _usageCode = r'''
final postsAsync = ref.watch(postsListProvider); // AsyncValue<List<Post>>

postsAsync.when(
  data: (posts) => /* 목록 */,
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => Text('에러: $e'),
);

// 새로고침
ref.invalidate(postsListProvider);
''';
