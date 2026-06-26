import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'persistence_providers.dart';

/// 토픽 18: 오프라인 영속성(실험적) — riverpod_sqflite 로 상태를 로컬 DB 에 저장.
class PersistencePage extends ConsumerWidget {
  const PersistencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterAsync = ref.watch(persistedCounterProvider);
    // 핵심: persist 로 복원된 값은 "AsyncLoading + value(cache)" 상태로 온다.
    // 따라서 .when(로딩→스피너) 대신 .value 로 그려야 값이 보인다. isLoading 이어도 값 접근 가능.
    final count = counterAsync.value;

    return ConceptPage(
      title: '18. 오프라인 영속성 (실험적)',
      explanation:
          'riverpod_sqflite 의 JsonSqFliteStorage 와 Notifier.persist 로 상태를 로컬 SQLite 에 '
          '저장합니다. 아래 카운터를 올린 뒤 앱을 완전히 껐다 다시 켜도 값이 복원됩니다. '
          'persist 는 build 안에서 호출하며, 상태가 바뀔 때마다 자동으로 DB 에 기록하고 '
          '첫 build 때 저장값을 decode 해 복원합니다. (데스크톱/모바일에서 동작; 웹은 별도 설정 필요.)',
      points: const [
        'storageProvider: JsonSqFliteStorage.open 으로 DB 오픈',
        'persist(storage, key, encode, decode): 자동 저장 + 복원',
        '상태 변경 시 추가 코드 없이 자동으로 DB 반영',
        '주의: 복원된 값은 AsyncLoading+value(cache) 로 온다 → .when 대신 .value 로 렌더',
        'AsyncValue.isFromCache: 값이 캐시에서 왔는지 구분(isLoading 도 true)',
        '데스크톱은 main 에서 sqflite ffi 초기화 필요',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // 값이 있으면(=복원됐거나 초기값) 표시. 진짜 값이 없을 때만 스피너/에러.
              if (count != null) ...[
                Text('$count',
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 4),
                Text(
                  counterAsync.isFromCache
                      ? '💾 저장소에서 복원된 값입니다 (isFromCache=true)'
                      : '앱을 재시작해도 이 값이 유지됩니다',
                  textAlign: TextAlign.center,
                ),
              ] else if (counterAsync.isLoading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              else if (counterAsync.hasError)
                Text(
                  '저장소 오류: ${counterAsync.error}\n'
                  '(웹은 sqflite 미지원 — 데스크톱/모바일에서 동작합니다)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () =>
                        ref.read(persistedCounterProvider.notifier).reset(),
                    child: const Text('리셋'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton.icon(
                    onPressed: () =>
                        ref.read(persistedCounterProvider.notifier).increment(),
                    icon: const Icon(Icons.add),
                    label: const Text('증가(자동 저장)'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'persistence_providers.dart', code: _code),
      ],
    );
  }
}

const String _code = r'''
@Riverpod(keepAlive: true)
Future<JsonSqFliteStorage> storage(Ref ref) =>
    JsonSqFliteStorage.open('riverpod_tutorial.db');

@riverpod
class PersistedCounter extends _$PersistedCounter {
  @override
  Future<int> build() async {
    persist(
      ref.watch(storageProvider.future),
      key: 'persisted_counter',
      encode: (state) => state.toString(),
      decode: (encoded) => int.parse(encoded),
    );
    return 0; // 저장값이 없을 때 기본값
  }
  Future<void> increment() async => state = AsyncData((state.value ?? 0) + 1);
}

// UI: 복원값은 isLoading=true 로 오므로 .when 이 아니라 .value 로 그린다
final count = ref.watch(persistedCounterProvider).value; // 로딩 중에도 값 접근
if (count != null) Text('$count') else const CircularProgressIndicator();
''';
