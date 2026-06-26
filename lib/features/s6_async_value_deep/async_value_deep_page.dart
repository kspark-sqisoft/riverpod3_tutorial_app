import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../s2_future/future_providers.dart'; // postsListProvider 재사용

/// 토픽 21: AsyncValue 심화 — 재요청 중에도 이전 데이터를 유지하는 매끄러운 UX.
class AsyncValueDeepPage extends ConsumerWidget {
  const AsyncValueDeepPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(postsListProvider);
    final posts = async.value; // 데이터(로딩/에러 중에도 이전 값이 남아 있을 수 있음)

    return ConceptPage(
      title: '21. AsyncValue 심화',
      explanation:
          'AsyncValue 는 단순 when 외에도 풍부한 속성을 제공합니다. isLoading/isRefreshing/'
          'isReloading 으로 "처음 로딩"과 "새로고침"을 구분하고, value(또는 requireValue)로 '
          '이전 데이터에 접근할 수 있습니다. 이를 이용하면 새로고침 중에도 기존 목록을 그대로 '
          '두고 상단에만 진행 표시를 띄워 스피너 깜빡임을 없앨 수 있습니다. 새로고침을 눌러 '
          '목록이 사라지지 않고 유지되는지 확인하세요.',
      points: const [
        'value: 데이터(없으면 null) / requireValue: 없으면 예외',
        'isLoading: 로딩 중 / isRefreshing: 이전 데이터 있고 새로고침 중',
        '새로고침 시 value 를 그대로 그리면 깜빡임 없는 UX',
        'hasValue / hasError 로 상태 확인',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 상태 플래그 표시
              Text(
                'isLoading=${async.isLoading} · isRefreshing=${async.isRefreshing} · '
                'hasValue=${async.hasValue} · 개수=${posts?.length ?? 0}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              // 새로고침 중이면 상단에만 진행 바(목록은 유지)
              if (async.isLoading) const LinearProgressIndicator(),
              const SizedBox(height: 8),
              if (posts != null)
                // 이전/현재 데이터를 항상 표시 → 새로고침해도 사라지지 않음
                ...posts.take(5).map((p) => ListTile(
                      dense: true,
                      leading: CircleAvatar(child: Text('${p.id}')),
                      title: Text(p.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ))
              else if (async.isLoading)
                const Center(child: Padding(
                  padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
              else if (async.hasError)
                Text('에러: ${async.error}'),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                onPressed: () => ref.invalidate(postsListProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('새로고침(목록 유지 확인)'),
              ),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'AsyncValue 심화 사용', code: _code),
      ],
    );
  }
}

const String _code = r'''
final async = ref.watch(postsListProvider);
final posts = async.value; // 새로고침 중에도 이전 데이터 접근

Column(children: [
  if (async.isLoading) const LinearProgressIndicator(), // 상단 진행만
  if (posts != null)
    ...posts.map(buildTile)   // 데이터는 계속 표시 → 깜빡임 없음
  else if (async.isLoading)
    const CircularProgressIndicator(),
]);

// isRefreshing: 이전 데이터가 있는 상태의 재요청
// requireValue: 데이터가 확실할 때 (없으면 예외)
''';
