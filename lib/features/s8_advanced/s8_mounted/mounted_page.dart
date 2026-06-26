import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';
import 'mounted_providers.dart';

/// 토픽 37: ref.mounted — 비동기 작업 후 provider 생존 확인.
class MountedPage extends ConsumerWidget {
  const MountedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(slowTaskProvider);

    return ConceptPage(
      title: '37. ref.mounted (비동기 후 생존 확인)',
      explanation:
          'await 로 비동기 작업을 기다리는 동안 provider 가 폐기될 수 있습니다(autoDispose + 사용자가 '
          '화면을 떠남). 이때 await 뒤에서 state 를 그대로 갱신하면 "이미 폐기된 provider"를 건드려 '
          '오류가 납니다. ref.mounted 는 위젯의 BuildContext.mounted 와 같은 개념으로, "이 provider 가 '
          '아직 살아있는가"를 알려줍니다. await 후 if (!ref.mounted) return; 으로 안전하게 중단하세요.',
      points: const [
        'await 뒤에는 provider 가 폐기됐을 수 있다(특히 autoDispose)',
        'ref.mounted == false 면 state 갱신 금지(오류/낭비 방지)',
        '위젯의 BuildContext.mounted 의 provider 버전',
        '테스트: 작업 시작 후 3초 안에 다른 토픽 갔다 오기',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(status, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => ref.read(slowTaskProvider.notifier).run(),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('느린 작업 시작 (3초)'),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '💡 시작 후 3초 안에 왼쪽 목차에서 다른 토픽을 눌렀다가 이 토픽으로 돌아오세요.\n'
                    '그 사이 provider 가 폐기되어 로그에 ref.mounted = false 가 찍히고 갱신이 중단됩니다.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 200),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'mounted_providers.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
@riverpod
class SlowTask extends _$SlowTask {
  @override
  String build() => '대기 중';

  Future<void> run() async {
    state = '작업 중...';
    await Future.delayed(const Duration(seconds: 3)); // 이 사이 폐기될 수 있음
    if (!ref.mounted) return;   // 폐기됐으면 중단 → state 갱신 안 함(안전)
    state = '완료';
  }
}
''';
