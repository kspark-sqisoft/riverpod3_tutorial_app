import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/s0_basics/intro_page.dart';
import '../features/s0_provider/provider_basics_page.dart';
import '../features/s1_legacy/legacy_page.dart';
import '../features/s1_notifier/notifier_page.dart';
import '../features/s2_async_notifier/async_notifier_page.dart';
import '../features/s2_future/future_page.dart';
import '../features/s2_stream/stream_page.dart';
import '../features/s3_autodispose_keepalive/keepalive_page.dart';
import '../features/s3_family/family_page.dart';
import '../features/s3_select/select_page.dart';
import '../features/s4_city_weather/city_weather_page.dart';
import '../features/s4_lifecycle/lifecycle_page.dart';
import '../features/s4_listen/listen_page.dart';
import '../features/s5_clean_arch/presentation/clean_arch_page.dart';
import '../features/s5_gorouter_auth/gorouter_auth_page.dart';
import '../features/s5_mutations/mutations_page.dart';
import '../features/s5_override/override_page.dart';
import '../features/s5_persistence/persistence_page.dart';
import '../features/s5_retry_error/retry_page.dart';
import '../features/s5_testing/testing_page.dart';
import '../features/s6_async_value_deep/async_value_deep_page.dart';
import '../features/s6_debounce/debounce_page.dart';
import '../features/s6_ops/ops_page.dart';
import '../features/s6_scoping/scoping_page.dart';
import '../features/s7_signals/s7_async_state/async_state_page.dart';
import '../features/s7_signals/s7_basics/signal_basics_page.dart';
import '../features/s7_signals/s7_batch_untracked/batch_untracked_page.dart';
import '../features/s7_signals/s7_comparison/comparison_page.dart';
import '../features/s7_signals/s7_computed/computed_page.dart';
import '../features/s7_signals/s7_dependency/dependency_page.dart';
import '../features/s7_signals/s7_effect/effect_page.dart';
import '../features/s7_signals/s7_future/future_signal_page.dart';
import '../features/s7_signals/s7_lifecycle/signals_lifecycle_page.dart';
import '../features/s8_advanced/s8_cache_for/cache_for_page.dart';
import '../features/s8_advanced/s8_invalidate_refresh/invalidate_refresh_page.dart';
import '../features/s8_advanced/s8_keepalive_pages/keepalive_pages_page.dart';
import '../features/s8_advanced/s8_mounted/mounted_page.dart';
import '../features/s8_advanced/s8_pagination/pagination_page.dart';
import '../features/s8_advanced/s8_cancel/cancel_page.dart';
import '../features/s8_advanced/s8_pull_to_refresh/pull_to_refresh_page.dart';
import '../home/landing_page.dart';
import '../shared/placeholder_page.dart';
import 'app_shell.dart';
import 'toc.dart';

/// 토픽 id → 실제 페이지 빌더 매핑.
///
/// 단계적 구현: 여기에 등록된 토픽은 실제 페이지로, 없으면 [PlaceholderPage] 로 연결된다.
/// (B~E 단계에서 각 토픽을 구현하며 이 맵을 채운다.)
final Map<String, WidgetBuilder> topicPages = <String, WidgetBuilder>{
  'intro': (context) => const IntroPage(), // 토픽 1
  'provider': (context) => const ProviderBasicsPage(), // 토픽 2
  'notifier': (context) => const NotifierPage(), // 토픽 3
  'legacy': (context) => const LegacyPage(), // 토픽 4
  'future': (context) => const FuturePage(), // 토픽 5
  'async_notifier': (context) => const AsyncNotifierPage(), // 토픽 6
  'stream': (context) => const StreamPage(), // 토픽 7
  'family': (context) => const FamilyPage(), // 토픽 8
  'keepalive': (context) => const KeepAlivePage(), // 토픽 9
  'select': (context) => const SelectPage(), // 토픽 10
  'lifecycle': (context) => const LifecyclePage(), // 토픽 11
  'city_weather': (context) => const CityWeatherPage(), // 토픽 12
  'listen': (context) => const ListenPage(), // 토픽 13
  'clean_arch': (context) => const CleanArchPage(), // 토픽 14
  'override': (context) => const OverridePage(), // 토픽 15
  'retry': (context) => const RetryPage(), // 토픽 16
  'mutations': (context) => const MutationsPage(), // 토픽 17
  'persistence': (context) => const PersistencePage(), // 토픽 18
  'gorouter_auth': (context) => const GoRouterAuthPage(), // 토픽 19
  'testing': (context) => const TestingPage(), // 토픽 20
  'async_value_deep': (context) => const AsyncValueDeepPage(), // 토픽 21
  'debounce': (context) => const DebouncePage(), // 토픽 22
  'scoping': (context) => const ScopingPage(), // 토픽 23
  'ops': (context) => const OpsPage(), // 토픽 24
  // S7 Signals 비교
  'signal_basics': (context) => const SignalBasicsPage(), // 토픽 25
  'computed': (context) => const ComputedPage(), // 토픽 26
  'effect': (context) => const EffectPage(), // 토픽 27
  'future_signal': (context) => const FutureSignalPage(), // 토픽 28
  'async_state': (context) => const AsyncStateDeepPage(), // 토픽 29
  'signals_dependency': (context) => const DependencyPage(), // 토픽 30
  'signals_lifecycle': (context) => const SignalsLifecyclePage(), // 토픽 31
  'batch_untracked': (context) => const BatchUntrackedPage(), // 토픽 32
  'comparison': (context) => const ComparisonPage(), // 토픽 33
  // S8 실전 패턴
  'cache_for': (context) => const CacheForPage(), // 토픽 34
  'pagination': (context) => const PaginationPage(), // 토픽 35
  'invalidate_refresh': (context) => const InvalidateRefreshPage(), // 토픽 36
  'mounted': (context) => const MountedPage(), // 토픽 37
  'keepalive_pages': (context) => const KeepAlivePagesPage(), // 토픽 38
  'pull_to_refresh': (context) => const PullToRefreshPage(), // 토픽 39
  'cancel': (context) => const CancelPage(), // 토픽 40
};

/// 앱 라우터. ShellRoute 로 사이드바(AppShell)를 유지한 채 콘텐츠(child)만 교체한다.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    ShellRoute(
      // 모든 자식 라우트를 AppShell 로 감싼다 → 사이드바 공유
      builder: (context, state, child) => AppShell(child: child),
      routes: <RouteBase>[
        // 기본 라우트: 환영 페이지 (NoTransitionPage → 전환 애니메이션 없음)
        GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              const NoTransitionPage(child: LandingPage()),
        ),
        // 목차의 모든 토픽 라우트를 자동 생성
        for (final topic in allTopics)
          GoRoute(
            path: topic.path,
            // pageBuilder + NoTransitionPage: 콘텐츠 교체 시 확대/페이드 전환 제거
            pageBuilder: (context, state) {
              final builder = topicPages[topic.id]; // 구현된 페이지가 있으면 사용
              final child = builder != null
                  ? builder(context)
                  : PlaceholderPage(title: topic.title); // 없으면 준비중 페이지
              return NoTransitionPage(child: child);
            },
          ),
      ],
    ),
  ],
);
