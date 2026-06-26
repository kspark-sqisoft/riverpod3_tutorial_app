// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 인증 상태(로그인 여부)를 관리하는 Notifier.
/// 실제 앱에서는 이 상태를 go_router 의 redirect 가드와 연결해 보호 라우트를 통제한다.

@ProviderFor(Auth)
final authProvider = AuthProvider._();

/// 인증 상태(로그인 여부)를 관리하는 Notifier.
/// 실제 앱에서는 이 상태를 go_router 의 redirect 가드와 연결해 보호 라우트를 통제한다.
final class AuthProvider extends $NotifierProvider<Auth, bool> {
  /// 인증 상태(로그인 여부)를 관리하는 Notifier.
  /// 실제 앱에서는 이 상태를 go_router 의 redirect 가드와 연결해 보호 라우트를 통제한다.
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$authHash() => r'11bca63c7a98317728fdf0df83fccf2169837330';

/// 인증 상태(로그인 여부)를 관리하는 Notifier.
/// 실제 앱에서는 이 상태를 go_router 의 redirect 가드와 연결해 보호 라우트를 통제한다.

abstract class _$Auth extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
