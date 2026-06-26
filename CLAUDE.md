# CLAUDE.md

이 파일은 이 저장소에서 작업하는 Claude Code(claude.ai/code)에게 가이드를 제공합니다.

## 프로젝트 개요

**flutter_riverpod 3.3.2**를 기초부터 고급까지 한 토픽당 한 페이지로 가르치는 학습/레퍼런스용 Flutter 앱입니다. 각 토픽 페이지는 **한국어 설명 + 라이브 데모 + 실제 소스 스니펫**으로 구성됩니다. 데이터는 공개 API dummyjson.com(`/posts`, `/todos`)을 사용합니다. **UI 텍스트와 코드 주석은 한국어로 작성**합니다.

## 명령어

```bash
flutter pub get
dart run build_runner build      # @riverpod / @JsonSerializable 파일 수정 후 *.g.dart 재생성
dart run build_runner watch      # 개발 중 자동 재생성
flutter analyze                  # 작업 완료 전 반드시 0 issues 여야 함
flutter test                     # test/providers_test.dart + test/widget_test.dart 실행
flutter test test/providers_test.dart                 # 단일 파일
flutter test --plain-name "add 하면 항목이 늘어난다"    # 이름으로 단일 테스트
flutter run -d windows           # 데스크톱 (sqflite 영속성 등 전 기능)
flutter run -d chrome            # 웹 (영속성 토픽은 graceful 하게 동작)
flutter build web                # 릴리스; CanvasKit + dart2js. 산출물: build/web/
```

provider 파일을 수정하면 **반드시 `build_runner`를 돌려야** 합니다. 안 하면 `flutter analyze`가 `_$...` 심볼 누락으로 실패합니다. (이 build_runner 버전에서 `--delete-conflicting-outputs`는 deprecated — 경고만 뜨고 무해)

## 아키텍처 — TOC 기반 셸

앱 전체가 **단일 소스** `lib/app/toc.dart`(`kToc`)에서 생성됩니다. 무엇을 추가하기 전에 이 흐름을 먼저 이해하세요:

- `lib/app/toc.dart` — `kToc`는 `TocSection` → `TocTopic(number, id, title)` 리스트. `topic.path`는 `'/topic/<id>'`.
- `lib/app/router.dart` — `ShellRoute` 하나를 가진 `GoRouter`. `allTopics`의 **모든** 토픽에 대해 `GoRoute`를 자동 생성하고, `topic.id` → 페이지 위젯을 `topicPages` 맵으로 연결. 맵에 없는 id는 `PlaceholderPage`로 폴백. 라우트는 `NoTransitionPage` 사용(전환 애니메이션 없음, 의도된 설계).
- `lib/app/app_shell.dart` — `AppShell`이 `ShellRoute` 빌더: 왼쪽 **`kToc`로 만든 사이드바**(네비게이션 동안 유지, 현재 라우트 하이라이트) + 오른쪽 콘텐츠. 반응형: 너비 800px 미만이면 사이드바가 `Drawer`로 전환.

### 새 토픽 추가 (가장 흔한 작업)
1. `lib/features/<section>_<name>/<name>_page.dart` (필요하면 `<name>_providers.dart`도) 생성.
2. `kToc`(`lib/app/toc.dart`)의 알맞은 섹션에 `TocTopic` 추가.
3. `topicPages`(`lib/app/router.dart`)에 `'<id>': (context) => const XxxPage()` 등록 + import 추가.
4. `dart run build_runner build` → `flutter analyze`.

### 페이지 구성
모든 토픽 페이지는 `ConceptPage`(`lib/shared/concept_page.dart`)를 반환: `title` + `ExplanationCard` + `demo` 위젯 + `CodeSnippet` 리스트. **화면의 `CodeSnippet` 문자열은 실제 파일 코드와 일치시키는 것이 원칙**이니, 로직을 바꾸면 스니펫도 함께 갱신하세요.

### 학습 로그 인프라
- `lib/shared/app_logger.dart` — 전역 `log`(`AppLogger.instance`). 이중 sink: 콘솔 출력 + 화면용 `ValueNotifier<List<LogEntry>>`(`LifecycleLogView`가 렌더). provider/observer가 `log.t/d/i/w/e(...)`로 서술형 한국어 메시지를 남겨 사용자가 라이프사이클을 실시간으로 본다.
- **`AppLogger`는 빌드 단계 안전(build-phase-safe)**: 동기적으로 버퍼에 쌓고, 빌드/레이아웃 중 호출되면(예: `ref.watch`가 provider를 mount하는 동안 `ProviderObserver` 발화) `addPostFrameCallback`으로 `ValueNotifier` 갱신을 프레임 이후로 미룬다. 이걸 다시 직접 `entries.value =`로 "단순화"하지 말 것 — "setState during build" 예외가 난다.
- `lib/app/lifecycle_observer.dart` — `LifecycleObserver extends ProviderObserver`, `main.dart`의 `ProviderScope(observers: [...])`에 등록되어 모든 provider 이벤트를 `log`로 전달.

### 데이터 / DI
- `lib/api/dummyjson_client.dart` — 순수 `http` 클라이언트(riverpod 무관), 테스트에서 가짜로 교체하기 쉬움.
- `lib/api/api_providers.dart` — `dummyJsonClientProvider`(`@Riverpod(keepAlive: true)`). DI 이음새(seam) — 테스트와 override 토픽이 이걸 교체한다.
- 커리큘럼 섹션: `s0`–`s6` = riverpod 코어→고급; `s7_signals` = **signals 비교**(`signals_flutter` 사용, codegen 없음); `s8_advanced` = 실전 패턴(cacheFor 시간제 캐시, 페이지네이션, invalidate/refresh, `ref.mounted`, keepAlive 체감).

## 이 프로젝트 특유의 규약 & 함정

- **코드생성 우선.** provider는 `@riverpod` / `@Riverpod(keepAlive: true)`를 쓰고 `part '*.g.dart'`가 있는 `*_providers.dart`에 둔다. `.g.dart` 파일은 **커밋한다**.
- **provider 파일은 `package:riverpod_annotation/riverpod_annotation.dart`만 import** — 이게 `Ref`, `Notifier`, `AsyncValue`, `AsyncData` 등을 re-export 한다. 여기에 `flutter_riverpod`를 추가하면 `unnecessary_import` 린트가 뜬다. 페이지/위젯 파일은 `ConsumerWidget`/`Consumer`/`WidgetRef`를 위해 `package:flutter_riverpod/flutter_riverpod.dart`를 import.
- **AsyncValue(3.3.2):** `.value`(nullable `T?`) 사용 — `valueOrNull`은 여기 **없다**. `copyWithPrevious`는 `@internal`이라 쓰지 말 것. persist/캐시 복원 상태는 값을 가진 `AsyncLoading`(`isFromCache == true`)으로 오므로 `.when()`(영원히 스피너) 대신 `.value`로 렌더한다.
- **`riverpod_lint` / `custom_lint`는 의도적으로 pubspec에 없음** — 이 툴체인(Dart 3.12.2 / Flutter 3.44)에서는 `riverpod_generator`/`test`가 끌어오는 `analyzer`보다 낮은 버전을 요구해 의존성 해결이 실패한다. 다시 추가하지 말 것.
- 실험적 API: Mutations는 `package:flutter_riverpod/experimental/mutation.dart`; `persist`(riverpod_sqflite)는 `package:flutter_riverpod/experimental/persist.dart`.
- **데스크톱 영속성:** `main.dart`가 `lib/app/db_init.dart`의 `initDatabaseFactory()`를 호출. 이는 조건부 import(`dart.library.io`면 `db_init_ffi.dart`, 웹이면 `db_init_stub.dart`)라서 웹 빌드를 깨지 않고 Windows/데스크톱에서 sqflite가 동작한다.
- **signals(s7):** signals 7.x에서 `Watch`·`SignalsMixin`은 deprecated — `SignalBuilder(builder: ...)` 또는 `SignalWidget` 사용. 위젯 안에서 만든 지역 signal은 직접 `.dispose()` 해야 함(riverpod 같은 DI/autoDispose 없음).
- riverpod/signals의 정확한 API 형태를 확인할 땐 추측하지 말고 pub 캐시의 설치된 패키지 소스(`~/AppData/Local/Pub/Cache/hosted/pub.dev/<pkg>-<ver>/lib/`)를 읽을 것 — 최신(bleeding-edge) 버전이다.
- `docs/prd.md`는 제품/커리큘럼 명세(S0–S8 토픽 목록과 근거)다.
