import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'select_providers.dart';

/// 토픽 10: select & 최적화 — 필요한 부분만 구독해 불필요한 rebuild 방지.
class SelectPage extends ConsumerWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConceptPage(
      title: '10. select & 최적화',
      explanation:
          'ref.watch(provider.select((s) => s.일부)) 처럼 상태의 "일부"만 구독하면, '
          '그 부분이 바뀔 때만 위젯이 다시 그려집니다. 아래 두 카드의 "빌드 횟수"를 보세요. '
          '나이를 바꾸면 전체를 watch 하는 카드만 리빌드되고, 이름만 select 하는 카드는 '
          '리빌드되지 않습니다(이름이 그대로이므로).',
      points: const [
        'select: 상태의 특정 부분만 구독',
        '선택한 값이 == 로 동일하면 위젯을 rebuild 하지 않음',
        '큰 객체 상태에서 잦은 rebuild 를 줄이는 핵심 최적화',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          _FullWatcher(), // 전체 구독
          SizedBox(height: 8),
          _NameWatcher(), // 이름만 select
          SizedBox(height: 8),
          _Controls(), // 변경 버튼들
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'select 사용', code: _code),
      ],
    );
  }
}

/// 전체 상태를 watch → 어떤 필드가 바뀌어도 rebuild.
class _FullWatcher extends ConsumerStatefulWidget {
  const _FullWatcher();
  @override
  ConsumerState<_FullWatcher> createState() => _FullWatcherState();
}

class _FullWatcherState extends ConsumerState<_FullWatcher> {
  int _builds = 0;
  @override
  Widget build(BuildContext context) {
    _builds++; // 이 위젯이 다시 그려질 때마다 증가
    final profile = ref.watch(profileControllerProvider); // 전체 구독
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        title: Text('전체 watch: $profile'),
        trailing: Text('빌드 $_builds회'),
      ),
    );
  }
}

/// 이름만 select → 이름이 바뀔 때만 rebuild(나이 변경엔 반응 안 함).
class _NameWatcher extends ConsumerStatefulWidget {
  const _NameWatcher();
  @override
  ConsumerState<_NameWatcher> createState() => _NameWatcherState();
}

class _NameWatcherState extends ConsumerState<_NameWatcher> {
  int _builds = 0;
  @override
  Widget build(BuildContext context) {
    _builds++;
    // 이름만 구독 → age 가 바뀌어도 이 위젯은 rebuild 되지 않는다
    final name = ref.watch(profileControllerProvider.select((p) => p.name));
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        title: Text('name select: $name'),
        trailing: Text('빌드 $_builds회'),
      ),
    );
  }
}

/// 상태 변경 버튼들.
class _Controls extends ConsumerWidget {
  const _Controls();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(profileControllerProvider.notifier);
    return Row(
      children: [
        FilledButton.tonal(
          // 나이 변경 → 전체 watcher 만 리빌드
          onPressed: () => ref.read(profileControllerProvider.notifier).birthday(),
          child: const Text('나이 +1'),
        ),
        const SizedBox(width: 8),
        FilledButton.tonal(
          // 이름 변경 → 두 카드 모두 리빌드
          onPressed: () => notifier.rename(
            ref.read(profileControllerProvider).name == '홍길동' ? '김철수' : '홍길동',
          ),
          child: const Text('이름 토글'),
        ),
      ],
    );
  }
}

const String _code = r'''
// 전체 구독: 어떤 필드가 바뀌어도 rebuild
final profile = ref.watch(profileControllerProvider);

// 일부만 구독: name 이 바뀔 때만 rebuild (age 변경엔 무반응)
final name = ref.watch(profileControllerProvider.select((p) => p.name));
''';
