import 'package:flutter/material.dart';

import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';

// (기능, Riverpod, signals) 비교 행 데이터.
const List<(String, String, String)> _rows = [
  ('상태 선언', '@riverpod provider', 'signal() 전역 변수'),
  ('파생/합성', '파생 Provider · select', 'computed (자동 추적)'),
  ('사이드이펙트', 'ref.listen · listenSelf', 'effect'),
  ('비동기', 'FutureProvider · AsyncValue', 'futureSignal · AsyncState'),
  ('의존 추적', 'ref.watch (명시적)', '읽으면 자동 의존 (암묵적)'),
  ('DI 컨테이너', '✅ ProviderScope', '❌ (전역 · get_it · InheritedWidget)'),
  ('family (파라미터화)', '✅ 내장', '❌ (Map<Key,Signal> 수동)'),
  ('scoping / override', '✅ ProviderScope.overrides', '❌ (InheritedWidget 등)'),
  ('전역 관찰', '✅ ProviderObserver', '❌'),
  ('자동 재시도', '✅ 내장(지수 백오프)', '❌ (직접 구현)'),
  ('Mutations', '✅ 실험적(@mutation)', '❌'),
  ('오프라인 영속성', '✅ riverpod_sqflite', '❌ (effect + 저장소 수동)'),
  ('라이프사이클 콜백', '✅ onAddListener/onCancel/onResume/onDispose', '△ dispose 정도'),
  ('batch / untracked', '❌ (직접 대응 없음)', '✅ 내장'),
  ('코드생성', 'build_runner(@riverpod)', '불필요'),
  ('테스트', '✅ ProviderContainer.test', '✅ 평범한 객체라 쉬움'),
  ('성격', '체계적 · 기능 풍부 · 보일러플레이트 多', '가볍고 미세반응 · 보일러플레이트 少'),
];

/// 토픽 33: 차이 요약 — Riverpod이 가진 것 / signals가 가진 것.
class ComparisonPage extends StatelessWidget {
  const ComparisonPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ConceptPage(
      title: '33. 차이 요약 — Riverpod vs signals',
      explanation:
          'signals 는 가볍고 미세한 반응형 프리미티브(signal/computed/effect)에 강하고, 의존 추적이 '
          '자동이라 보일러플레이트가 적습니다. 반면 Riverpod 은 DI 컨테이너·family·scoping/override·'
          'ProviderObserver·자동 재시도·Mutations·영속성·세밀한 라이프사이클 등 "앱 규모의 상태/의존성 '
          '관리"에 필요한 기능을 폭넓게 내장합니다. 아래 표로 핵심 차이를 정리합니다.',
      points: const [
        '작은 위젯 상태·파생·미세 반응 → signals 가 간결',
        '대규모 DI·테스트·관찰·고급 비동기 → Riverpod 이 강력',
        'signals 의 미지원 영역은 전역/get_it/InheritedWidget 등으로 보완',
        '둘은 함께 쓰기도 함(예: signals 로 로컬 UI 상태, Riverpod 로 DI)',
      ],
      demo: Card(
        clipBehavior: Clip.antiAlias,
        child: Table(
          border: TableBorder.symmetric(
            inside: BorderSide(color: scheme.outlineVariant, width: 0.5),
          ),
          columnWidths: const {
            0: FlexColumnWidth(1.1),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(1.4),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // 헤더
            TableRow(
              decoration: BoxDecoration(color: scheme.primaryContainer),
              children: [
                _cell('기능', bold: true),
                _cell('Riverpod', bold: true),
                _cell('signals', bold: true),
              ],
            ),
            // 데이터 행
            for (final (feature, riverpod, signals) in _rows)
              TableRow(
                children: [
                  _cell(feature, bold: true),
                  _cell(riverpod),
                  _cell(signals),
                ],
              ),
          ],
        ),
      ),
      // 있고/없고를 "코드로" 비교 — DI 컨테이너, family, override
      snippets: const [
        CodeSnippet(title: 'DI 컨테이너: Riverpod vs signals(get_it)', code: _diCode),
        CodeSnippet(title: 'family: Riverpod vs signals(Map)', code: _familyCode),
        CodeSnippet(title: 'override: Riverpod vs signals', code: _overrideCode),
      ],
    );
  }

  Widget _cell(String text, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 12.5,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        ),
      );
}

const String _diCode = r'''
// Riverpod: DI 컨테이너 내장(ProviderScope) — provider 로 등록, ref 로 주입
@riverpod ApiClient apiClient(Ref ref) => ApiClient();
@riverpod Repo repo(Ref ref) => Repo(ref.watch(apiClientProvider)); // 자동 주입
// 사용: ref.watch(repoProvider)

// signals: DI 내장 없음 → get_it 같은 서비스 로케이터로 직접 배선
final getIt = GetIt.instance;
void setup() {
  getIt.registerLazySingleton(() => ApiClient());
  getIt.registerLazySingleton(() => Repo(getIt<ApiClient>()));
}
// 사용: getIt<Repo>()   (또는 전역 변수 / InheritedWidget)
''';

const String _familyCode = r'''
// Riverpod: family 내장 — 인자별 인스턴스 + 자동 캐시
@riverpod Future<Post> postById(Ref ref, int id) => fetch(id);
// 사용: ref.watch(postByIdProvider(3))

// signals: family 내장 없음 → Map<key, Signal> 로 직접 캐시
final _cache = <int, FutureSignal<Post>>{};
FutureSignal<Post> postById(int id) =>
    _cache.putIfAbsent(id, () => futureSignal(() => fetch(id)));
// 사용: postById(3).value   (폐기/정리도 직접 관리해야 함)
''';

const String _overrideCode = r'''
// Riverpod: ProviderScope.overrides 로 교체(테스트/환경/오프라인)
ProviderScope(
  overrides: [repoProvider.overrideWithValue(FakeRepo())],
  child: app,
);

// signals: 내장 override 없음 → get_it 재등록 또는 전역 교체로 흉내
getIt.registerSingleton<Repo>(FakeRepo()); // 테스트에서 가짜로 교체
''';
