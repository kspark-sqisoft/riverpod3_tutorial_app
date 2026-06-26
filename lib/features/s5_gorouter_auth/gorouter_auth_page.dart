import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'auth_providers.dart';

/// 토픽 19: go_router + Riverpod 통합 — 인증 가드.
///
/// 이 페이지는 인증 상태(authProvider)에 따라 화면을 가르는 "redirect 의 축소판"을 보여준다.
/// 실제 앱에서의 GoRouter redirect + refreshListenable 연결 방법은 코드 스니펫 참고.
class GoRouterAuthPage extends ConsumerWidget {
  const GoRouterAuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(authProvider); // 인증 상태 구독

    return ConceptPage(
      title: '19. go_router + Riverpod 통합',
      explanation:
          '인증 상태를 Notifier 로 두고, go_router 의 redirect 에서 그 상태를 읽어 보호 라우트를 '
          '통제합니다. 상태가 바뀌면 redirect 가 다시 평가되도록 refreshListenable 에 '
          '"provider 를 듣는 Listenable"을 연결합니다. 아래 데모는 그 가드 동작을 한 화면에서 '
          '재현한 것입니다(로그인 전엔 보호 콘텐츠가 가려짐).',
      points: const [
        'authProvider(Notifier): 로그인 상태 보관',
        'GoRouter.redirect: 상태를 읽어 /login 등으로 이동 결정',
        'refreshListenable: 상태 변화 시 redirect 재평가 트리거',
        '보호 라우트는 redirect 한 곳에서 일관되게 통제',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: loggedIn
              // 로그인됨 → 보호 콘텐츠
              ? Column(
                  children: [
                    const Icon(Icons.lock_open, size: 48, color: Colors.green),
                    const SizedBox(height: 8),
                    Text('🔓 보호된 콘텐츠',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    const Text('로그인 상태에서만 볼 수 있는 화면입니다.'),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => ref.read(authProvider.notifier).logout(),
                      icon: const Icon(Icons.logout),
                      label: const Text('로그아웃'),
                    ),
                  ],
                )
              // 로그아웃됨 → 로그인 화면(redirect 가 막은 상태를 흉내)
              : Column(
                  children: [
                    const Icon(Icons.lock, size: 48, color: Colors.grey),
                    const SizedBox(height: 8),
                    Text('🔒 로그인이 필요합니다',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    const Text('redirect 가드가 보호 콘텐츠 접근을 막은 상태입니다.'),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => ref.read(authProvider.notifier).login(),
                      icon: const Icon(Icons.login),
                      label: const Text('로그인'),
                    ),
                  ],
                ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'GoRouter redirect 연동', code: _code),
      ],
    );
  }
}

const String _code = r'''
// provider 를 듣는 Listenable (상태 변화 → redirect 재평가)
class AuthListenable extends ChangeNotifier {
  AuthListenable(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

final router = GoRouter(
  refreshListenable: AuthListenable(ref),
  redirect: (context, state) {
    final loggedIn = ref.read(authProvider);
    final atLogin = state.matchedLocation == '/login';
    if (!loggedIn && !atLogin) return '/login'; // 보호 라우트 차단
    if (loggedIn && atLogin) return '/';          // 로그인 후 복귀
    return null;                                   // 그대로 진행
  },
  routes: [ /* ... */ ],
);
''';
