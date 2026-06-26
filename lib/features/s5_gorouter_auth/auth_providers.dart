import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

/// 인증 상태(로그인 여부)를 관리하는 Notifier.
/// 실제 앱에서는 이 상태를 go_router 의 redirect 가드와 연결해 보호 라우트를 통제한다.
@riverpod
class Auth extends _$Auth {
  @override
  bool build() => false; // 초기: 로그아웃

  void login() => state = true;
  void logout() => state = false;
}
