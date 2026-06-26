// 학습 목차(Table of Contents)의 단일 소스(Single Source of Truth).
//
// 사이드바 메뉴와 go_router 라우트를 모두 이 데이터에서 파생한다.
// 토픽을 추가/순서변경하려면 여기 kToc 만 고치면 된다.

/// 토픽 하나의 메타데이터.
class TocTopic {
  const TocTopic({required this.number, required this.id, required this.title});

  final int number; // 토픽 번호(1~24) — 사이드바에 표시
  final String id; // 라우트/페이지 식별자(예: 'intro')
  final String title; // 한국어 제목

  /// 라우트 경로. ShellRoute 의 자식 경로로 사용된다.
  String get path => '/topic/$id';
}

/// 섹션(S0~S6) — 토픽들을 묶는 단위.
class TocSection {
  const TocSection({required this.code, required this.title, required this.topics});

  final String code; // 'S0' 같은 섹션 코드
  final String title; // 섹션 한국어 제목
  final List<TocTopic> topics; // 소속 토픽들
}

/// 전체 커리큘럼. (PRD 의 S0~S6, 토픽 1~24)
const List<TocSection> kToc = <TocSection>[
  TocSection(code: 'S0', title: '시작하기', topics: [
    TocTopic(number: 1, id: 'intro', title: '소개 & ProviderScope'),
    TocTopic(number: 2, id: 'provider', title: 'Provider (기본)'),
  ]),
  TocSection(code: 'S1', title: '동기 상태', topics: [
    TocTopic(number: 3, id: 'notifier', title: 'NotifierProvider'),
    TocTopic(number: 4, id: 'legacy', title: 'Legacy 비교'),
  ]),
  TocSection(code: 'S2', title: '비동기 (dummyjson)', topics: [
    TocTopic(number: 5, id: 'future', title: 'FutureProvider & AsyncValue'),
    TocTopic(number: 6, id: 'async_notifier', title: 'AsyncNotifierProvider'),
    TocTopic(number: 7, id: 'stream', title: 'StreamProvider & StreamNotifier'),
  ]),
  TocSection(code: 'S3', title: '프로바이더 제어', topics: [
    TocTopic(number: 8, id: 'family', title: 'family (파라미터)'),
    TocTopic(number: 9, id: 'keepalive', title: 'autoDispose & keepAlive'),
    TocTopic(number: 10, id: 'select', title: 'select & 최적화'),
  ]),
  TocSection(code: 'S4', title: '라이프사이클', topics: [
    TocTopic(number: 11, id: 'lifecycle', title: '라이프사이클 콜백'),
    TocTopic(number: 12, id: 'city_weather', title: '의존 + 라이프사이클 (도시→날씨)'),
    TocTopic(number: 13, id: 'listen', title: 'ref.listen & 사이드이펙트'),
  ]),
  TocSection(code: 'S5', title: '아키텍처 & DI', topics: [
    TocTopic(number: 14, id: 'clean_arch', title: 'DI 컨테이너 & 클린 아키텍처'),
    TocTopic(number: 15, id: 'override', title: 'override & 의존성 교체'),
    TocTopic(number: 16, id: 'retry', title: '에러 처리 & 자동 재시도'),
    TocTopic(number: 17, id: 'mutations', title: 'Mutations (실험적)'),
    TocTopic(number: 18, id: 'persistence', title: '오프라인 영속성 (실험적)'),
    TocTopic(number: 19, id: 'gorouter_auth', title: 'go_router + Riverpod 통합'),
    TocTopic(number: 20, id: 'testing', title: '테스트'),
  ]),
  TocSection(code: 'S6', title: '현업 심화 패턴', topics: [
    TocTopic(number: 21, id: 'async_value_deep', title: 'AsyncValue 심화'),
    TocTopic(number: 22, id: 'debounce', title: '비동기 합성·취소·디바운스'),
    TocTopic(number: 23, id: 'scoping', title: 'Provider 스코핑'),
    TocTopic(number: 24, id: 'ops', title: '운영(Operations) 패턴'),
  ]),
  TocSection(code: 'S7', title: 'Signals 비교', topics: [
    TocTopic(number: 25, id: 'signal_basics', title: 'signal 기본 (Builder/Widget)'),
    TocTopic(number: 26, id: 'computed', title: 'computed (파생)'),
    TocTopic(number: 27, id: 'effect', title: 'effect (사이드이펙트)'),
    TocTopic(number: 28, id: 'future_signal', title: 'FutureSignal (비동기)'),
    TocTopic(number: 29, id: 'async_state', title: 'AsyncState 심화 & Stream'),
    TocTopic(number: 30, id: 'signals_dependency', title: '의존 체인 (도시→날씨)'),
    TocTopic(number: 31, id: 'signals_lifecycle', title: 'autoDispose & 라이프사이클'),
    TocTopic(number: 32, id: 'batch_untracked', title: 'batch & untracked'),
    TocTopic(number: 33, id: 'comparison', title: '차이 요약 (vs Riverpod)'),
  ]),
  TocSection(code: 'S8', title: '실전 패턴', topics: [
    TocTopic(number: 34, id: 'cache_for', title: 'keepAlive 시간제 캐시 (cacheFor)'),
    TocTopic(number: 35, id: 'pagination', title: '페이지네이션 / 무한 스크롤'),
    TocTopic(number: 36, id: 'invalidate_refresh', title: 'invalidate vs refresh'),
    TocTopic(number: 37, id: 'mounted', title: 'ref.mounted (비동기 후 생존 확인)'),
    TocTopic(number: 38, id: 'keepalive_pages', title: 'keepAlive 체감 (여러 페이지)'),
  ]),
];

/// 모든 토픽을 한 줄로 펼친 목록(라우트 생성 등에 사용).
List<TocTopic> get allTopics =>
    kToc.expand((section) => section.topics).toList(growable: false);
