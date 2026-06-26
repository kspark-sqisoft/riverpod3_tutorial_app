import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/async_value_view.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'retry_providers.dart';

/// 토픽 16: 에러 처리 & 자동 재시도.
class RetryPage extends ConsumerWidget {
  const RetryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(autoRetryDemoProvider);

    return ConceptPage(
      title: '16. 에러 처리 & 자동 재시도',
      explanation:
          'Riverpod 3 은 실패한 provider 를 지수 백오프(200ms→6.4s)로 자동 재시도합니다. '
          '아래 provider 는 시도 #1, #2 에서 일부러 실패하고 #3 에서 성공합니다. 별도 코드 '
          '없이도 자동으로 재시도되어 결국 성공하는 흐름을 로그에서 확인하세요. 새로고침으로 '
          '다시 실패→재시도 사이클을 재현할 수 있습니다.',
      points: const [
        '자동 재시도: 실패 시 지수 백오프로 자동 재실행',
        'AsyncValue.guard / try-catch 로 에러를 명시적으로 다룰 수도 있음',
        'Ref.mounted: 비동기 작업 후 provider 가 살아있는지 확인(폐기 후 갱신 방지)',
        '수동 재시도: ref.invalidate(provider)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AsyncValueView<String>(
                    value: async,
                    onRetry: () => ref.invalidate(autoRetryDemoProvider),
                    data: (msg) => Text(msg,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => ref.invalidate(autoRetryDemoProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('새로고침(실패→재시도 재현)'),
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
        CodeSnippet(title: 'retry_providers.dart', code: _providerCode),
        CodeSnippet(title: 'Ref.mounted 패턴', code: _mountedCode),
      ],
    );
  }
}

const String _providerCode = r'''
@riverpod
Future<String> autoRetryDemo(Ref ref) async {
  final attempt = ++_attempt;
  await Future.delayed(const Duration(milliseconds: 300));
  if (attempt % 3 != 0) {
    throw Exception('일시적 오류');  // 실패 → Riverpod 이 자동 재시도(백오프)
  }
  return '성공!';
}
''';

const String _mountedCode = r'''
// 비동기 작업 후 provider 가 이미 폐기됐을 수 있으므로 mounted 확인
Future<void> load() async {
  final data = await api.fetch();
  if (!ref.mounted) return;  // 폐기됐으면 중단(상태 갱신 안 함)
  state = AsyncData(data);
}
''';
