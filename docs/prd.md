# flutter_riverpod 3.3.2 심화 학습 튜토리얼 앱 — PRD

> 본 문서는 검토 완료된 제품 요구사항(PRD)입니다. 구현은 아래 "구현 단계"와 "검증" 절차를 따릅니다.

## Context (배경 / 목적)

flutter_riverpod **3.3.2**를 기초부터 고급까지 한 화면씩 직접 보며 학습하는 Flutter 앱을 만든다.
- **레이아웃**: 왼쪽에 **목차 사이드바(스터디 순서: S0~S6, 토픽 목록)**, 오른쪽 **콘텐츠 영역**. 목차 항목을 누르면 사이드바는 유지된 채 콘텐츠 영역만 해당 토픽 페이지로 교체된다(go_router `ShellRoute`). 좁은 화면에선 사이드바를 `Drawer`로 전환(반응형).
- 각 토픽 페이지(콘텐츠 영역)에서 **개념 설명(한국어) + 라이브 데모 + 예제 코드 스니펫**을 함께 본다.
- **학습 목적이므로**: 모든 예제 코드에 **풍부한 한 줄 한글 주석**을 달고, `logger`로 **의미 있는 학습용 로그**(provider build/dispose, async 상태 전이, 라이프사이클 콜백, DI resolve 순서)를 콘솔+화면에 서술형으로 남긴다.
- 작성 방식은 **코드생성(`@riverpod` + build_runner) 위주** (사용자 선택). Mutations 같은 codegen 전용 기능도 다룰 수 있다.
- 데이터는 dummyjson(`/posts`, `/todos`)을 사용해 비동기 프로바이더를 실제 네트워크로 실습한다.
- 다루는 핵심: Provider, NotifierProvider, FutureProvider, AsyncNotifierProvider, StreamProvider/StreamNotifier, family, autoDispose/keepAlive, AsyncValue, select, **프로바이더 간 의존(도시→날씨 파생)**, 라이프사이클(Uninitialized→Alive→Paused→Disposed), 라이프사이클 콜백(`onAddListener`/`onRemoveListener`/`onCancel`/`onDispose`/`onResume`) + ref.listen, override, 자동 재시도, **Riverpod을 DI 컨테이너로 본 의존성 주입(DI) + 간단한 클린 아키텍처(layer 분리)**, 고급 옵션 4종(테스트 / go_router 통합 / Mutations / 오프라인 영속성), **그리고 현업 고수 패턴(AsyncValue 심화 · 비동기 합성/취소/디바운스 · provider 스코핑 · 운영 observer 패턴)까지 빠짐없이 포함**.

현재 상태: 막 생성된 기본 Flutter 스캐폴드(`lib/main.dart`는 카운터 데모). riverpod·go_router·http 등 의존성 없음. Dart SDK `^3.12.2`, Windows 데스크톱 타깃 폴더 존재.

검증된 Riverpod 3.x 사양 (공식 문서 확인):
- 함수형: `@riverpod T name(Ref ref)` / `Future<T>` / `Stream<T>`
- 클래스형: `@riverpod class X extends _$X { @override T build() {...} ...메서드 }`
- family: `family` 모디파이어 없이 **함수/`build`에 인자 추가**
- keepAlive: `@Riverpod(keepAlive: true)` (기본은 autoDispose, AutoDispose 인터페이스는 3.0에서 통합됨)
- 통합 `Ref` 타입, `Ref.mounted`, 자동 retry(지수 백오프 200ms→6.4s)
- pause/resume: 위젯이 보이지 않으면(`TickerMode`) 자동 일시정지
- `StateProvider`/`StateNotifierProvider`는 `package:flutter_riverpod/legacy.dart`로 이동(권장 안 함)
- 영속성: `riverpod_sqflite`의 `JsonSqFliteStorage.open` + 노티파이어 `build` 내 `persist(...)`, `AsyncValue.isFromCache`
- Mutations: **codegen 전용**, 노티파이어 메서드에 `@mutation`
- 테스트: `ProviderContainer.test()`, `overrideWith`/`overrideWithValue`/`overrideWithBuild`
- ProviderObserver(3.x): 콜백이 `ProviderObserverContext`(provider/container 포함) 인자를 받는 형태로 변경 — `didAddProvider(context, value)` / `didUpdateProvider(context, prev, next)` / `didDisposeProvider(context)` / `providerDidFail(context, error, stack)`. 구현 시 정확 시그니처 확인 필요.
- 구분 주의: **pause/resume**(구독 일시정지, rebuild 보류, TickerMode 자동) ≠ **onCancel/onResume**(리스너 0 ↔ 재구독) ≠ **autoDispose 폐기**(리스너 0 + 유지 안 함 → onDispose).

---

## 의존성 (pubspec.yaml)

> 정확한 버전은 구현 시 `flutter pub add`로 확정. 아래는 목표 메이저 버전.

dependencies:
- `flutter_riverpod: ^3.3.2`  — ProviderScope / ConsumerWidget
- `riverpod_annotation: ^3.x`  — `@riverpod` 어노테이션
- `go_router: ^16.x` (latest)  — 라우팅
- `http: ^1.x`  — dummyjson 호출
- `json_annotation: ^4.x`  — 모델 직렬화
- `logger: ^2.x`  — **학습용 로깅**(라이프사이클·상태전이·DI 배선을 콘솔에 서술형으로 기록)
- `riverpod_sqflite` (latest, 실험적)  — 오프라인 영속성
- `sqflite_common_ffi: ^2.x`  — **Windows/데스크톱에서 sqflite 동작에 필수**

dev_dependencies:
- `build_runner: ^2.x`
- `riverpod_generator: ^4.x` (riverpod_annotation 4.x 와 짝)
- `json_serializable: ^6.x`
- ~~`riverpod_lint` + `custom_lint`~~ — **구현 시 제외**: Dart 3.12.2/Flutter 3.44 환경에서 이들이 요구하는 analyzer(≤9.x)가 riverpod_generator·test 가 끌어온 analyzer 12.x 와 충돌. 린트 도구가 최신 analyzer 미지원이라 의존성 해결 실패 → 앱/튜토리얼 동작에 불필요하므로 뺌.

> 실제 해결 버전: flutter_riverpod 3.3.2 · riverpod_annotation 4.0.3 · riverpod_generator 4.0.4 · go_router 17.3.0 · riverpod_sqflite 0.4.3 · logger 2.7.0 · json_serializable 6.14.0 · sqflite_common_ffi 2.4.2.
> 웹 시각 검증을 위해 `flutter create . --platforms=web` 로 web/ 추가함(데스크톱 타깃 유지).

`analysis_options.yaml`에 `custom_lint` 플러그인 활성화 추가.

---

## 폴더 구조

```
lib/
  main.dart                      # ProviderScope(observers:[..]) + MaterialApp.router
                                 #   + (데스크톱) sqflite_common_ffi 초기화
  app/
    router.dart                  # GoRouter: ShellRoute(사이드바 유지) + 토픽별 자식 라우트
    app_shell.dart               # 좌: 목차 사이드바 / 우: 콘텐츠(라우터 child). 반응형(좁으면 Drawer)
    toc.dart                     # 목차 데이터: 섹션(S0~S6)→토픽(제목·라우트 경로) 단일 소스
    theme.dart                   # Material 3 라이트/다크 테마
    lifecycle_observer.dart      # ProviderObserver → 라이프사이클 이벤트를 로그 Notifier로 전달
  api/
    dummyjson_client.dart        # http 기반 클라이언트(posts/todos GET·POST·PUT·DELETE)
    models/{post.dart, todo.dart}# @JsonSerializable 모델(+ .g.dart)
  shared/
    app_logger.dart              # logger 래퍼: 콘솔 출력 + 화면 로그(LifecycleLogView)로 동시 sink
    concept_page.dart            # 페이지 공통 템플릿(제목·설명·데모·코드 영역)
    explanation_card.dart        # 한국어 개념 설명 카드
    code_snippet.dart            # 코드 스니펫 표시(monospace 박스 + 복사 버튼)
    async_value_view.dart        # AsyncValue → data/loading/error 렌더 헬퍼
    lifecycle_log_view.dart      # 라이프사이클 이벤트 실시간 리스트
  home/
    landing_page.dart            # 기본 라우트('/')에서 콘텐츠 영역에 표시되는 환영/안내 페이지
  features/                      # 토픽 1개 = 폴더 1개 (page widget + providers + .g.dart)
    s0_basics/ s0_provider/
    s1_notifier/ s1_legacy/
    s2_future/ s2_async_notifier/ s2_stream/
    s3_family/ s3_autodispose_keepalive/ s3_select/
    s4_lifecycle/ s4_city_weather/ s4_listen/   # s4_city_weather: 도시→날씨 의존+라이프사이클
    # s4_city_weather: selected_city/weather(city) family/unit 프로바이더 + 라이프사이클 로그
    s5_clean_arch/              # 14: 간단한 클린 아키텍처 + DI 컨테이너
      domain/                  #   Todo 엔티티, 추상 TodoRepository, GetTodos 유스케이스(선택)
      data/                    #   TodoRepositoryImpl, DummyJsonClient 데이터소스, DTO 매핑
      application/             #   todoListController(AsyncNotifier)
      presentation/            #   페이지 + 위젯
      providers.dart           #   DI 배선: client→repo→(usecase)→controller (+ .g.dart)
    s5_override/ s5_retry_error/ s5_mutations/ s5_persistence/ s5_gorouter_auth/ s5_testing/
test/
  providers_test.dart            # 토픽 20(테스트)에서 실제로 작성·실행
```

각 토픽 페이지는 `ConceptPage`로 통일: 상단 **개념 설명 카드(한국어)** → 가운데 **라이브 데모** → 하단 **접이식 코드 스니펫**. 코드 스니펫은 개발자가 직접 쓰는 `@riverpod` 소스(생성된 `.g.dart` 아님)를 보여준다.

---

## 커리큘럼 (페이지 = 학습 단위)

**S0. 시작하기**
1. **소개 & ProviderScope** — Riverpod 개요, `ProviderScope`, `ConsumerWidget`/`Consumer`/**`ConsumerStatefulWidget`**(initState에서 ref 사용), `WidgetRef` vs `Ref`, `ref.watch` vs `read` vs `listen` 차이, 코드생성 셋업(`dart run build_runner build`/**`watch`** 모드) 설명
2. **Provider(기본)** — 읽기 전용 값 제공, 의존성 주입, `ref.watch`로 파생/합성 provider

**S1. 동기 상태**
3. **NotifierProvider** — `@riverpod class` + `build()` + 상태변경 메서드 (카운터 → 할일 리스트)
4. **Legacy 비교(짧게)** — `StateProvider`/`StateNotifierProvider`가 `legacy`로 간 이유, Notifier로의 대체 (설명 카드 위주)

**S2. 비동기 (dummyjson 연동)**
5. **FutureProvider & AsyncValue** — `/posts` 로드, `AsyncValue.when(data/loading/error)`, `AsyncValue.guard`
6. **AsyncNotifierProvider** — `/todos` CRUD + 낙관적 업데이트 + `ref.invalidateSelf`/`ref.refresh`
7. **StreamProvider & StreamNotifier** — 주기적 스트림 시뮬레이션, AsyncValue로 수신

**S3. 프로바이더 제어**
8. **family(파라미터)** — `postById(int id)`, `todosByUser(int userId)` (함수 인자 방식)
9. **autoDispose & keepAlive** — 기본 autoDispose 동작, `@Riverpod(keepAlive: true)`, `ref.keepAlive()`, 캐시 유지 타이머 데모
10. **select & 최적화** — `ref.watch(p.select(...))`로 부분 구독, 불필요한 rebuild 방지를 리빌드 카운터로 시각화

**S4. 라이프사이클**
11. **프로바이더 라이프사이클 콜백** — Uninitialized→Alive→Paused→Disposed 도식 + 모든 `ref` 콜백을 한 화면에서 실시간으로 확인:
    - `ref.onAddListener` (구독 추가), `ref.onRemoveListener` (구독 해제), `ref.onCancel` (마지막 리스너 제거 → 일시 비활성), `ref.onResume` (다시 구독), `ref.onDispose` (폐기)
    - `ProviderObserver`(`didAddProvider`/`didUpdateProvider`/`didDisposeProvider`/`providerDidFail`)와 위 `ref` 콜백을 **시간순 로그로 화면에 표시**(`LifecycleLogView`)
    - 위젯 가시성 토글(보임/숨김)로 자동 pause/resume, 구독 토글 버튼으로 onCancel↔onResume 시연
12. **프로바이더 간 의존 + 라이프사이클 (도시→날씨)** — 핵심 시나리오:
    - `selectedCityProvider`(Notifier, 선택된 도시) → `weatherProvider(city)` **family**가 도시별 날씨를 비동기 로드. 화면에서 도시를 바꾸면 해당 도시 날씨 표시.
    - `weatherProvider`는 다시 `unitProvider`(섭씨/화씨 설정)를 `ref.watch` → **의존 체인**(unit → weather → UI) 형성. 단위를 바꾸면 살아있는 weather가 rebuild.
    - 도시 전환 시: 이전 `weather(oldCity)`는 리스너 잃음 → `onRemoveListener`→`onCancel`→(autoDispose)`onDispose`, 새 `weather(newCity)`는 `onAddListener`→`build`. 이 전 과정이 라이프사이클 로그에 실시간으로 찍혀 **의존 프로바이더의 생성·폐기**를 눈으로 확인.
    - `keepAlive` on/off 토글로 도시 재선택 시 캐시 재사용 vs 재요청 차이 비교.
    - 날씨 데이터는 외부 키 불필요하도록 **모의 비동기 함수**(도시별 결정적 mock + 인위적 지연)로 구현(실제 API는 옵션).
13. **ref.listen & 사이드이펙트** — 상태 변화 → 스낵바/다이얼로그/네비게이션, `ref.listenSelf` (예: 날씨 로드 실패 시 스낵바)

**S5. 아키텍처 & 의존성 주입(DI)**
14. **Riverpod = DI 컨테이너 & 간단한 클린 아키텍처** — 핵심:
    - 개념: Riverpod의 `ProviderContainer`가 곧 **DI 컨테이너**, 각 provider가 의존성 **등록(registration)**, `ref.watch/read`가 **resolve(주입)**, `override`가 **rebind**. 생성자 주입(DI) 대비 장점(전역 트리·자동 폐기·테스트 교체) 설명.
    - 실습(간단한 형태 — 3레이어 기본): Todos 슬라이스를 `presentation`(페이지/위젯 + 컨트롤러 Notifier) → `domain`(엔티티 `Todo`, 추상 `TodoRepository`) → `data`(`TodoRepositoryImpl` + `DummyJsonClient`, DTO 매핑)로 분리. **유스케이스(`GetTodos`)는 "한 단계 더"의 선택 레이어로 별도 표기**(과한 추상화 경계를 학습자가 직접 비교).
    - 배선(DI 그래프): `dummyJsonClientProvider` → `todoRepositoryProvider`(추상 타입 반환) → `(getTodosProvider 선택)` → `todoListControllerProvider`(AsyncNotifier) → UI. 화면에 **의존성 그래프 도식** 표시.
    - 핵심 포인트: domain은 Flutter/HTTP를 모름(의존성 역전), UI는 추상 타입만 watch.
15. **override & 의존성 교체(DI 실전)** — `ProviderScope(overrides:[...])`로 `todoRepositoryProvider`를 **Fake 구현**으로 교체(오프라인/데모/테스트). 14의 클린 아키텍처 배선을 그대로 재사용해 "추상에 의존하면 교체가 쉽다"를 시연.
16. **에러 처리 & 자동 재시도** — Riverpod 3 자동 retry(지수 백오프), `Ref.mounted`, 에러 UI/수동 재시도
17. **Mutations(실험적)** — `@mutation`으로 Todo 추가 폼 제출의 loading/success/error 추적
18. **오프라인 영속성(실험적)** — `riverpod_sqflite` + `JsonSqFliteStorage`, `Notifier.persist`, `AsyncValue.isFromCache`로 캐시/서버 구분 (데스크톱은 ffi 초기화)
19. **go_router + Riverpod 통합** — 로그인 상태 Notifier + `redirect` 가드 + `refreshListenable` 연동(인증 흐름)
20. **테스트** — `ProviderContainer.test()`, `overrideWith*`(14의 repository를 Fake로 주입), 비동기 provider 테스트. 화면엔 설명/코드, 실제 `test/providers_test.dart`도 작성해 `flutter test` 통과

**S6. 현업 심화 패턴 (Production / Advanced)** — 고수 개발자들이 실무에서 쓰는 어려운 개념
21. **AsyncValue 심화** — `value`/`valueOrNull`/`requireValue`, `hasValue`/`hasError`, `isLoading` vs `isReloading` vs `isRefreshing`, `copyWithPrevious`/`unwrapPrevious`, `when(skipLoadingOnReload/skipLoadingOnRefresh/skipError)`. 재요청 중에도 **이전 데이터를 유지**하며 스피너 깜빡임 없는 매끄러운 UX 구현(현업 핵심).
22. **비동기 합성 · 취소 · 디바운스** — 여러 async provider를 `await ref.watch(p.future)`로 묶어 합성, `ref.onDispose`로 진행 중 요청/타이머 **취소**, autoDispose 기반 **디바운스 검색**(타이핑마다 이전 요청 취소). dummyjson `/posts/search?q=` 사용.
23. **Provider 스코핑(scoping)** — 중첩 `ProviderScope(overrides:[..])`로 **서브트리 한정** 값 주입(예: 리스트 아이템별 `currentItemProvider`), codegen `@Riverpod(dependencies: [..])` 명시, riverpod_lint 스코프 규칙. `Provider`로 위젯에 데이터를 흘려보내는 패턴.
24. **운영(Operations) 패턴** — `ProviderObserver`로 로깅/분석/Crashlytics 연동, `providerDidFail`로 **전역 에러 리포팅**, **eager initialization**(앱 시작 시 핵심 provider 워밍업), `ref.listenManual`(위젯 밖에서 구독), `WidgetRef` vs `Ref` 차이, `ref.read` 남용 안티패턴.

---

## 핵심 공유 인프라 (먼저 구축)

- **`ConceptPage`** 템플릿 + `ExplanationCard`/`CodeSnippet`/`AsyncValueView` — 모든 토픽이 재사용.
- **`LifecycleObserver`(ProviderObserver)** — `didAddProvider`/`didDisposeProvider`/`didUpdateProvider`/`providerDidFail`를 가로채 `AppLogger`로 보냄 → 콘솔 로그 + 로그용 Notifier push → 토픽 11·12·24에서 화면 표시. `main.dart`의 `ProviderScope(observers:)`에 등록.
- **`AppLogger`** — `logger` 패키지 래퍼. 단일 sink로 (1) 콘솔에 예쁘게 출력, (2) 화면 `LifecycleLogView`에 push. 레벨 컨벤션: `t`(상세 추적: build 시작/인자), `d`(상태 전이), `i`(주요 이벤트: dispose/네트워크), `w`(취소/재시도), `e`(`providerDidFail` 에러). 메시지는 **학습용 서술형 한국어**(예: `[weather(서울)] build 시작 — unit=섭씨 watch`).
- **`DummyJsonClient`** + `Post`/`Todo` 모델 — S2 이후 비동기 토픽 공통.
- **`AppShell` + `toc.dart`** — `ShellRoute`로 좌측 **목차 사이드바**(섹션 S0~S6 → 토픽 목록, 현재 라우트 하이라이트)를 유지한 채 우측 콘텐츠만 교체. 목차 데이터는 `toc.dart` 단일 소스에서 생성(라우터 라우트와 사이드바 항목을 함께 파생). 좁은 화면은 `Drawer`로 전환. 항목 클릭 → `context.go(route)`.

---

## 학습 보조: 코드 주석 & 로깅 규약 (필수)

학습용 앱이므로 **모든 예제 파일**에 아래 규약을 적용한다.

- **풍부한 한 줄 한글 주석**: 모든 riverpod 구문(어노테이션, `ref.watch/read/listen`, 콜백, `state=` 등) 옆/위에 "무엇을·왜"를 한 줄로 설명. 초보가 한 줄씩 따라 읽을 수 있게.
- **학습용 로그(logger)**: 각 provider의 build 진입/완료, 상태 전이, 라이프사이클 콜백, 네트워크 호출, DI resolve를 `AppLogger`로 서술형 한국어로 남김. 콘솔과 화면 로그에 동시에 보임.
- **화면 코드 스니펫과 일치**: 화면 하단 스니펫에 보여주는 코드 = 실제 파일 코드(주석 포함)와 동일하게 유지.

예시(토픽 12 weather provider):
```dart
// weather(city): 선택 도시의 날씨를 비동기 로드하는 family provider (autoDispose 기본)
@riverpod                                       // 코드생성으로 weatherProvider/_$Weather 생성
Future<Weather> weather(Ref ref, String city) async {
  final unit = ref.watch(unitProvider);         // 단위 provider에 의존 → unit이 바뀌면 이 build 재실행
  ref.onAddListener(() => log.t('[weather($city)] 구독 추가'));   // 첫 구독(Uninitialized→Alive)
  ref.onCancel(() => log.d('[weather($city)] 마지막 리스너 해제 → dispose 후보'));
  ref.onDispose(() => log.i('[weather($city)] dispose: 리소스 정리')); // 폐기 시 1회
  log.t('[weather($city)] build 시작 (unit=$unit)');            // build 진입 로그
  final data = await _fetchWeather(city, unit); // 모의 비동기 호출(인위적 지연)
  log.i('[weather($city)] 로드 완료: ${data.temp}°');
  return data;                                  // AsyncData로 UI에 전달
}
```

---

## 구현 단계 (제안)

- **A단계**: **`docs/prd.md` 저장(완료)** → 의존성 추가 → 폴더 구조 → `main.dart`/`router.dart`/`theme.dart` → 공유 인프라(`AppLogger`·`ConceptPage`·`ExplanationCard`·`CodeSnippet`·`AsyncValueView`·`LifecycleLogView`) → 홈 → 첫 build_runner 성공 확인.
- **B단계**: S0~S2 (기본·동기·비동기 + dummyjson 연동).  → **✅ MVP 지점**: A+B 완료 시 사이드바·기초·비동기까지 동작하는 학습앱이 완성됨(우선 동작 확인 권장). 이후 C~E는 점진 추가.
- **C단계**: S3~S4 (제어·라이프사이클).
- **D단계**: S5 아키텍처/DI + 고급 옵션(override·재시도·Mutations·영속성·go_router) + `test/` 작성.
- **E단계**: S6 현업 심화 패턴(AsyncValue 심화·취소/디바운스·스코핑·운영 패턴).

각 단계 끝에 `build_runner` / `flutter analyze` / 실행 확인.

---

## 검증 (Verification)

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs` — `.g.dart` 생성 성공(에러 0)
3. `flutter analyze` — riverpod_lint/custom_lint 경고 클린
4. `flutter run -d windows` (또는 `-d chrome`) — 좌측 목차 사이드바가 유지된 채 항목 클릭 시 우측 콘텐츠만 교체되고 현재 항목이 하이라이트되는지 확인, 창 크기를 줄이면 사이드바가 Drawer로 전환되는지 확인. 각 토픽 진입:
   - S2: dummyjson `/posts`·`/todos` 로딩→데이터 표시, 에러/재시도 동작
   - S3-9: keepAlive on/off에 따른 재생성 차이 확인
   - S4-11: 페이지 진입/이탈·가시성 토글·구독 토글 시 `onAddListener/onRemoveListener/onCancel/onResume/onDispose` 로그가 화면에 찍힘
   - S4-12: 도시 변경 시 이전 `weather(oldCity)`가 onRemoveListener→onCancel→onDispose 되고 새 `weather(newCity)`가 생성되는 과정이 로그에 표시, 단위 변경 시 weather rebuild 확인
   - S5-14: 클린 아키텍처 슬라이스가 동작(client→repo→(usecase)→controller→UI), 의존성 그래프 표시
   - S5-15: `override`로 `todoRepositoryProvider`를 Fake로 교체 시 UI가 가짜 데이터로 바뀜
   - S5-18: 앱 재시작 후 영속 상태 복원(`isFromCache`)
   - S5-19: 비로그인 시 redirect 가드 동작
   - S6-22: 검색창에 빠르게 타이핑 시 이전 요청이 취소되고 마지막 입력만 결과 반영(디바운스)
   - S6-23: 중첩 `ProviderScope`로 주입한 값이 해당 서브트리에서만 다르게 보임
5. `flutter test` — 토픽 20의 provider 테스트 통과

---

## 미해결/구현 시 결정할 소소한 항목
- 코드 스니펫 색상 강조: 우선 monospace 박스로 단순 구현, 필요 시 `flutter_highlight` 추가(옵션).
- go_router 버전·riverpod_sqflite 정확 버전은 `pub add` 결과로 확정.
- 실행 타깃 기본값: Windows 데스크톱(영속성 ffi 초기화 포함). 웹으로도 실행 가능하나 sqflite 영속성 토픽은 데스크톱/모바일에서 시연.

---

## 부록: 검토 이력
- 작성 방식(코드생성), 화면 코드 스니펫 표시, 한국어 설명, 고급 옵션 4종 포함은 사용자 확인 완료.
- 추가 반영: 도시→날씨 의존 + 라이프사이클 콜백(S4-12), 간단한 클린 아키텍처 + DI 컨테이너(S5-14), 현업 심화 패턴(S6), 학습용 logger + 풍부한 한글 주석, 좌측 목차 사이드바 레이아웃(ShellRoute).
- 자기검토(writing-plans 루브릭 + riverpod 3.x 정확성)로 보완: ProviderObserver 3.x 시그니처(`ProviderObserverContext`), pause/resume vs onCancel vs autoDispose 구분, `ConsumerStatefulWidget`·`build_runner watch` 추가, 클린아키텍처 3레이어 단순화(usecase 선택), MVP 마일스톤 명시.
