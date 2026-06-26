# riverpod3_tutorial_app

**flutter_riverpod 3.3.2**를 기초부터 현업 심화까지 한 화면에 하나씩 직접 보며 배우는 학습용 Flutter 앱입니다.
각 토픽 페이지는 **개념 설명(한국어) + 라이브 데모 + 예제 코드**로 구성되고, 화면/콘솔의 실시간 로그로 provider의 생성·갱신·폐기 흐름을 눈으로 확인할 수 있습니다.

## 특징

- 📚 **38개 토픽 / 8개 섹션(S0~S8)** — 왼쪽 목차 사이드바에서 선택, 콘텐츠만 교체(go_router `ShellRoute`)
- 🧩 **코드생성(@riverpod) 위주** — Provider/Notifier/Future/Stream/AsyncNotifier, family, autoDispose/keepAlive, select, 라이프사이클, 의존(도시→날씨), DI/간단한 클린아키텍처, override, 자동 재시도, Mutations, 오프라인 영속성, go_router 인증, 테스트, AsyncValue 심화, 디바운스/취소, scoping, 운영 패턴
- ⚡ **Signals 비교(S7)** — `signals_flutter`로 같은 개념을 구현해 Riverpod과 코드/차이를 나란히 비교
- 🛠 **실전 패턴(S8)** — keepAlive 시간제 캐시(cacheFor), 페이지네이션, invalidate vs refresh, `ref.mounted`, keepAlive 체감
- 📝 **학습용 로그 + 풍부한 한글 주석** — 모든 예제에 한 줄 주석, `logger` 기반 서술형 로그(콘솔+화면 동시)
- 🌐 **dummyjson.com** API(`/posts`, `/todos`)로 실제 네트워크 비동기 실습

## 기술 스택

Flutter 3.44 · Dart 3.12 · flutter_riverpod 3.3.2 · riverpod_generator 4 · go_router 17 · http · riverpod_sqflite(영속성) · signals_flutter 7(비교) · json_serializable

## 시작하기

```bash
flutter pub get
dart run build_runner build      # 코드생성(.g.dart)
flutter run -d windows           # 데스크톱(영속성 포함 전 기능)
flutter run -d chrome            # 웹
```

provider(`*_providers.dart`)를 수정하면 `dart run build_runner build`(또는 `watch`)로 다시 생성해야 합니다.

검증:

```bash
flutter analyze    # 0 issues 유지
flutter test       # provider/위젯 테스트
```

## 커리큘럼

| 섹션 | 내용 |
|---|---|
| S0 시작하기 | ProviderScope, Provider/파생 |
| S1 동기 상태 | NotifierProvider, Legacy 비교 |
| S2 비동기 | FutureProvider/AsyncValue, AsyncNotifier, StreamProvider |
| S3 제어 | family, autoDispose/keepAlive, select |
| S4 라이프사이클 | 콜백, 의존(도시→날씨), ref.listen |
| S5 아키텍처/DI | DI 컨테이너·클린아키텍처, override, 재시도, Mutations, 영속성, go_router, 테스트 |
| S6 현업 심화 | AsyncValue 심화, 디바운스/취소, scoping, 운영(Observer) |
| S7 Signals 비교 | signal/computed/effect/FutureSignal, 의존, batch/untracked, 차이 요약 |
| S8 실전 패턴 | cacheFor 시간제 캐시, 페이지네이션, invalidate/refresh, ref.mounted, keepAlive 체감 |

## 프로젝트 구조

```
lib/
  app/        라우터(ShellRoute) · 목차(toc) · 앱 셸 · 테마 · ProviderObserver
  api/        dummyjson 클라이언트 · 모델 · 공용 provider(DI seam)
  shared/     ConceptPage · 코드/설명/AsyncValue 위젯 · AppLogger · 로그뷰
  features/   토픽별 폴더(s0~s8): <name>_page.dart + <name>_providers.dart
  home/       랜딩 페이지
docs/prd.md   커리큘럼/제품 명세
```

> 개발 가이드(아키텍처·토픽 추가 방법·주의점)는 [`CLAUDE.md`](CLAUDE.md) 참고.
