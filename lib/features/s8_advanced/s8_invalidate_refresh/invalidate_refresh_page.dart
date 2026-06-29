import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/app_logger.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../../../shared/lifecycle_log_view.dart';
import 'invalidate_refresh_providers.dart';

/// 토픽 36: invalidate vs refresh 차이.
class InvalidateRefreshPage extends ConsumerWidget {
  const InvalidateRefreshPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(rebuildCounterProvider);

    return ConceptPage(
      title: '36. invalidate vs refresh',
      explanation:
          '둘 다 provider 를 "재계산"시키지만 차이가 있습니다. ref.invalidate(p) 는 상태를 무효화만 하고 '
          '반환값이 없으며(void), 재계산은 다음에 읽힐 때 지연 수행됩니다. ref.refresh(p) 는 무효화 후 '
          '곧바로 다시 읽어 새 값을 반환합니다(= invalidate + read). 즉 "새 값을 바로 써야 하면 refresh, '
          '그냥 무효화만 하면 invalidate" 입니다. 둘 다 watch 중이면 화면은 갱신됩니다. 아래 버튼과 '
          '로그(반환값 유무)로 차이를 확인하세요. '
          '또 하나 — invalidate(p)/refresh(p) 는 "다른" provider 를 밖에서 대상 지정해 무효화하는 것이고, '
          'notifier 가 "자기 자신"을 무효화할 땐 ref.invalidateSelf() 를 씁니다. 대상이 자신이라 인자가 '
          '없을 뿐, 효과는 invalidate(자기 provider) 와 같습니다(다음 read 때 build 재실행). 내부 새로고침은 '
          'invalidateSelf 가 정석입니다(밖에서 자기 provider 를 invalidate 하면 순환/타이밍 문제가 생기기 쉬움).',
      points: const [
        'invalidate(p): void · 지연 재계산(다음 read 때)',
        'refresh(p): 즉시 재계산하고 새 값 반환 (= invalidate + read)',
        '비동기 새로고침 완료를 기다리려면 await ref.refresh(p.future)',
        'invalidate(p)/refresh(p): 밖에서 "다른" provider 를 무효화(대상 지정)',
        'invalidateSelf(): notifier 안에서 "자기 자신"을 무효화(인자 없음, 효과는 invalidate 와 동일)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('rebuildCounter = $count',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  const Text('(지금까지 build 된 횟수 — 재계산될 때마다 증가)'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          ref.invalidate(rebuildCounterProvider);
                          log.i('🔸 invalidate() 호출 — 반환값 없음(void), 다음 read 때 재계산');
                        },
                        child: const Text('invalidate()'),
                      ),
                      FilledButton(
                        onPressed: () {
                          // refresh 는 새 값을 즉시 반환한다
                          final v = ref.refresh(rebuildCounterProvider);
                          log.i('🔹 refresh() 호출 — 즉시 재계산, 반환값 = $v');
                        },
                        child: const Text('refresh()'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 180),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'invalidate vs refresh', code: _code),
      ],
    );
  }
}

const String _code = r'''
// invalidate: void · 지연 재계산(다음 read 때)
ref.invalidate(counterProvider);

// refresh: invalidate + 즉시 read → 새 값을 반환
final newValue = ref.refresh(counterProvider);

// 비동기: 새로고침 "완료"를 기다리려면 .future 를 refresh (RefreshIndicator 등)
await ref.refresh(postsListProvider.future);

// 위 invalidate/refresh 는 "다른" provider 를 밖에서 무효화(대상 지정).
// notifier 가 "자기 자신"을 무효화할 땐 invalidateSelf — 대상이 자신이라 인자가 없다.
// (효과는 ref.invalidate(자기 provider) 와 동일: 다음 read 때 build 재실행)
class Todos extends _$Todos {
  Future<void> reload() async {
    ref.invalidateSelf(); // 자기 자신 무효화
    await future;         // 새 build 완료까지 대기(= 새로고침 패턴)
  }
}
''';
