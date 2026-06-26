// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 프로필 상태를 관리하는 Notifier. 이름/나이를 따로 바꿀 수 있다.

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

/// 프로필 상태를 관리하는 Notifier. 이름/나이를 따로 바꿀 수 있다.
final class ProfileControllerProvider
    extends $NotifierProvider<ProfileController, Profile> {
  /// 프로필 상태를 관리하는 Notifier. 이름/나이를 따로 바꿀 수 있다.
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Profile value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Profile>(value),
    );
  }
}

String _$profileControllerHash() => r'a30a2610ea1e45d6a19e32ec57151d6d44d4baf1';

/// 프로필 상태를 관리하는 Notifier. 이름/나이를 따로 바꿀 수 있다.

abstract class _$ProfileController extends $Notifier<Profile> {
  Profile build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Profile, Profile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Profile, Profile>,
              Profile,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
