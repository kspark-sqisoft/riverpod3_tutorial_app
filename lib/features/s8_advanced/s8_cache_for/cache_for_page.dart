import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../api/models/post.dart';
import '../../../shared/async_value_view.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';
import '../../s2_future/future_providers.dart'; // postsListProvider 재사용
import 'cache_for_providers.dart';

/// 토픽 34: keepAlive 시간제 캐시 (cacheFor).
class CacheForPage extends StatefulWidget {
  const CacheForPage({super.key});

  @override
  State<CacheForPage> createState() => _CacheForPageState();
}

class _CacheForPageState extends State<CacheForPage> {
  bool _show = true; // 구독 위젯 표시/숨김 → 구독 생성/해제

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '34. keepAlive 시간제 캐시 (cacheFor)',
      explanation:
          'autoDispose 는 구독이 0이 되면 즉시 폐기하고, keepAlive: true 는 영원히 유지합니다. '
          '그 중간이 "마지막 구독 해제 후 정해진 시간만 캐시 유지"입니다. ref.keepAlive() 로 link 를 '
          '잡고, onCancel 에서 타이머를 시작해 만료 시 link.close() 로 폐기하며, onResume 에서 타이머를 '
          '취소합니다. 아래 스위치로 구독을 껐다가 5초 안에 다시 켜면 "같은 값"(캐시 유지), 5초가 지나 '
          '켜면 "새 값"(재생성)이 됩니다. 아래 ② 는 실전 예: dummyjson 글 목록에서 글을 열면 상세를 '
          '받아오고 10초간 캐싱합니다. 목록으로 나갔다가 10초 안에 같은 글을 다시 열면 네트워크 '
          '재요청 없이 캐시로 즉시 표시되고(로그에 "캐시 사용"), 10초가 지나면 다시 요청합니다.',
      points: const [
        'ref.keepAlive(): 즉시 폐기를 막는 link 획득',
        'onCancel(구독 0) → Timer 시작 → 만료 시 link.close()로 폐기',
        'onResume(만료 전 재구독) → Timer 취소 → 캐시 유지',
        '실전: 글 상세를 10초간 캐싱 → 나갔다 들어와도 재요청 없음',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ① 기본: 스위치로 구독 on/off 하며 캐시 유지/재생성 관찰
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('① 구독 위젯 표시(ON) / 숨김(OFF)'),
                  subtitle: const Text('OFF 후 5초 안에 ON → 같은 값 / 5초 후 ON → 새 값'),
                  value: _show,
                  onChanged: (v) => setState(() => _show = v),
                ),
                if (_show) const Padding(
                  padding: EdgeInsets.all(16),
                  child: _CacheWatcher(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // ② 실전: dummyjson posts 목록 → 상세(캐시 적용)
          Text('② 글 목록 → 상세 (상세에 10초 캐시 적용)',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 4),
          const _CachedPostsDemo(),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 220),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'cacheForDemo (기본)', code: _code),
        CodeSnippet(title: 'cachedPost(id) — 상세에 캐시 적용', code: _postCode),
      ],
    );
  }
}

/// cacheForDemoProvider 를 구독하는 위젯. 사라지면 onCancel 이 트리거된다.
class _CacheWatcher extends ConsumerWidget {
  const _CacheWatcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cacheForDemoProvider);
    return AsyncValueView<String>(
      value: async,
      data: (value) => Text('캐시된 값: $value',
          style: Theme.of(context).textTheme.titleMedium),
    );
  }
}

/// 글 목록 ↔ 상세 전환. 상세를 열면 cachedPost(id) 구독이 생기고, 목록으로 나가면 해제된다.
class _CachedPostsDemo extends ConsumerStatefulWidget {
  const _CachedPostsDemo();

  @override
  ConsumerState<_CachedPostsDemo> createState() => _CachedPostsDemoState();
}

class _CachedPostsDemoState extends ConsumerState<_CachedPostsDemo> {
  int? _selectedId; // null = 목록, 값 있음 = 해당 글 상세

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 320,
        child: _selectedId == null
            ? _buildList()
            : _PostDetail(
                id: _selectedId!,
                onBack: () => setState(() => _selectedId = null), // 목록으로
              ),
      ),
    );
  }

  Widget _buildList() {
    final async = ref.watch(postsListProvider); // 토픽 5의 목록 provider 재사용
    return AsyncValueView<List<Post>>(
      value: async,
      onRetry: () => ref.invalidate(postsListProvider),
      data: (posts) => ListView(
        padding: const EdgeInsets.all(4),
        children: [
          for (final p in posts)
            ListTile(
              dense: true,
              leading: CircleAvatar(child: Text('${p.id}')),
              title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => setState(() => _selectedId = p.id), // 상세 열기
            ),
        ],
      ),
    );
  }
}

/// 캐시 적용 상세. cachedPost(id) 를 watch → 이 위젯이 사라지면 구독 해제(onCancel).
class _PostDetail extends ConsumerWidget {
  const _PostDetail({required this.id, required this.onBack});

  final int id;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cachedPostProvider(id)); // 10초 캐시 적용 상세
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            BackButton(onPressed: onBack),
            Text('글 #$id 상세', style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: AsyncValueView<Post>(
              value: async,
              onRetry: () => ref.invalidate(cachedPostProvider(id)),
              data: (post) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(post.body),
                  const SizedBox(height: 12),
                  Text('← 목록으로 나갔다가 10초 안에 같은 글을 다시 열면 캐시 사용(재요청 없음)',
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

const String _code = r'''
@riverpod
Future<String> cacheForDemo(Ref ref) async {
  final link = ref.keepAlive();          // 즉시 폐기 방지
  Timer? timer;

  ref.onCancel(() {                       // 마지막 구독 해제
    timer = Timer(const Duration(seconds: 5), link.close); // 5초 뒤 폐기
  });
  ref.onResume(() => timer?.cancel());    // 만료 전 재구독 → 캐시 유지
  ref.onDispose(() => timer?.cancel());   // 정리

  await Future.delayed(...);              // 생성 비용
  return createData();
}
''';

const String _postCode = r'''
// family + cacheFor: 글 상세를 10초간 캐싱
@riverpod
Future<Post> cachedPost(Ref ref, int id) async {
  final link = ref.keepAlive();
  Timer? timer;
  ref.onCancel(() =>                       // 상세 닫힘(구독 0)
      timer = Timer(const Duration(seconds: 10), link.close));
  ref.onResume(() => timer?.cancel());     // 10초 안 재진입 → 캐시 사용
  ref.onDispose(() => timer?.cancel());
  return ref.read(dummyJsonClientProvider).fetchPost(id); // 캐시 미스 때만 호출
}

// UI: 목록에서 글 탭 → 상세에서 watch(cachedPostProvider(id))
// 목록으로 나갔다 10초 안에 같은 글 → build 재실행 없음(= 네트워크 재요청 없음)
''';
