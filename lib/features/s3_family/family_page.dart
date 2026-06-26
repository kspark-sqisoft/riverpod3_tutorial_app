import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/models/post.dart';
import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'family_providers.dart';

/// 토픽 8: family — 파라미터화된 provider.
class FamilyPage extends ConsumerStatefulWidget {
  const FamilyPage({super.key});

  @override
  ConsumerState<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends ConsumerState<FamilyPage> {
  int _id = 1; // 선택된 게시글 id

  @override
  Widget build(BuildContext context) {
    // 선택된 id 로 family provider 를 구독. id 가 바뀌면 다른 인스턴스를 watch 한다.
    final postAsync = ref.watch(postByIdProvider(_id));

    return ConceptPage(
      title: '8. family (파라미터)',
      explanation:
          'family 는 파라미터에 따라 서로 다른 provider 인스턴스를 만드는 기능입니다. '
          '코드생성에서는 함수에 인자를 추가하기만 하면 됩니다. id 마다 독립적으로 캐시되어, '
          'postByIdProvider(1) 과 postByIdProvider(2) 는 별개의 상태를 가집니다.',
      points: const [
        '코드생성 family: 함수 인자 추가 (예: postById(Ref ref, int id))',
        '인자 값마다 별도 인스턴스 + 별도 캐시',
        '사용: ref.watch(postByIdProvider(id))',
        '인자는 == 비교로 식별되므로 동일 인자는 캐시 재사용',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('게시글 id 선택: '),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: _id,
                    items: [
                      for (var i = 1; i <= 10; i++)
                        DropdownMenuItem(value: i, child: Text('$i')),
                    ],
                    onChanged: (v) => setState(() => _id = v ?? 1),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AsyncValueView<Post>(
                value: postAsync,
                onRetry: () => ref.invalidate(postByIdProvider(_id)),
                data: (post) => ListTile(
                  leading: CircleAvatar(child: Text('${post.id}')),
                  title: Text(post.title),
                  subtitle: Text(post.body),
                ),
              ),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'family_providers.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
@riverpod
Future<Post> postById(Ref ref, int id) {     // 인자 = family 파라미터
  final client = ref.watch(dummyJsonClientProvider);
  return client.fetchPost(id);
}

// 사용처
final postAsync = ref.watch(postByIdProvider(selectedId));
''';
