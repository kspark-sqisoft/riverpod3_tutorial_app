import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../shared/signals_deps.dart';

// 게시글 비동기(심화 데모용) — refresh 시 이전 데이터 유지를 보여준다.
final _posts = futureSignal(() => signalsClient.fetchPosts(limit: 6));

// 1초마다 증가하는 스트림 → AsyncState<int> (Riverpod StreamProvider 대응)
Stream<int> _tick() async* {
  var i = 0;
  while (true) {
    yield i;
    i++;
    await Future<void>.delayed(const Duration(seconds: 1));
  }
}

final _ticker = streamSignal(_tick);

/// 토픽 29: AsyncState 심화 & StreamSignal. (Riverpod AsyncValue 심화 / StreamProvider 대응)
class AsyncStateDeepPage extends StatelessWidget {
  const AsyncStateDeepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '29. AsyncState 심화 & StreamSignal',
      explanation:
          'AsyncState 는 value/hasValue/isLoading/isRefreshing 등 풍부한 속성을 제공합니다. '
          'refresh() 는 isLoading 을 켜되 이전 데이터를 유지(AsyncDataRefreshing)하므로, .value 로 '
          '그리면 새로고침 중에도 목록이 사라지지 않습니다. streamSignal 은 스트림을 AsyncState 로 '
          '감쌉니다(Riverpod StreamProvider 대응).',
      points: const [
        'AsyncState: value / hasValue / isLoading / isRefreshing',
        'refresh(): 이전 데이터 유지하며 갱신(깜빡임 없음)',
        'reload(): 로딩부터 다시',
        'streamSignal: 스트림 → AsyncState (Riverpod StreamProvider 대응)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SignalBuilder(builder:(context) {
                final state = _posts.value;
                final posts = state.value; // 새로고침 중에도 접근 가능
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'isLoading=${state.isLoading} · isRefreshing=${state.isRefreshing} · '
                      'hasValue=${state.hasValue} · 개수=${posts?.length ?? 0}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (state.isLoading) const LinearProgressIndicator(),
                    const SizedBox(height: 4),
                    if (posts != null)
                      ...posts.map((p) => ListTile(
                            dense: true,
                            leading: CircleAvatar(child: Text('${p.id}')),
                            title: Text(p.title,
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ))
                    else
                      const Center(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CircularProgressIndicator())),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _posts.refresh(), // 이전 데이터 유지하며 갱신
                        icon: const Icon(Icons.refresh),
                        label: const Text('refresh(목록 유지)'),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('streamSignal (1초 틱)',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  // 스트림 값도 AsyncState — value 로 현재 값 표시
                  SignalBuilder(builder:(context) => Text('${_ticker.value.value ?? '-'}',
                      style: Theme.of(context).textTheme.displaySmall)),
                ],
              ),
            ),
          ),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'signals', code: _signalsCode),
        CodeSnippet(title: 'Riverpod (대응)', code: _riverpodCode),
      ],
    );
  }
}

const String _signalsCode = r'''
final posts = futureSignal(() => client.fetchPosts());
final ticker = streamSignal(() => tickStream());

SignalBuilder(builder:(context) {
  final s = posts.value;
  final list = s.value;                 // refresh 중에도 접근
  if (s.isLoading) showProgressBar();
  return list != null ? buildList(list) : spinner;
});
posts.refresh();                        // 이전 데이터 유지하며 갱신
''';

const String _riverpodCode = r'''
final async = ref.watch(postsListProvider);
final list = async.value;               // isRefreshing 중에도 접근
// StreamProvider:
@riverpod Stream<int> ticker(Ref ref) async* { ... }
''';
