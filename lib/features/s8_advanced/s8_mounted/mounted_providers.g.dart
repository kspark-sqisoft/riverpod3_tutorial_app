// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mounted_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ref.mounted 데모: 느린 비동기 작업 도중 provider 가 폐기될 수 있는 상황.
///
/// autoDispose(기본) provider 라서, 작업(await) 중에 사용자가 화면을 떠나면 폐기된다.
/// await 뒤에 state 를 그대로 갱신하면 "폐기된 provider 를 갱신"하게 되어 위험하다.
/// → ref.mounted 로 아직 살아있는지 확인하고, 아니면 안전하게 중단한다.

@ProviderFor(SlowTask)
final slowTaskProvider = SlowTaskProvider._();

/// ref.mounted 데모: 느린 비동기 작업 도중 provider 가 폐기될 수 있는 상황.
///
/// autoDispose(기본) provider 라서, 작업(await) 중에 사용자가 화면을 떠나면 폐기된다.
/// await 뒤에 state 를 그대로 갱신하면 "폐기된 provider 를 갱신"하게 되어 위험하다.
/// → ref.mounted 로 아직 살아있는지 확인하고, 아니면 안전하게 중단한다.
final class SlowTaskProvider extends $NotifierProvider<SlowTask, String> {
  /// ref.mounted 데모: 느린 비동기 작업 도중 provider 가 폐기될 수 있는 상황.
  ///
  /// autoDispose(기본) provider 라서, 작업(await) 중에 사용자가 화면을 떠나면 폐기된다.
  /// await 뒤에 state 를 그대로 갱신하면 "폐기된 provider 를 갱신"하게 되어 위험하다.
  /// → ref.mounted 로 아직 살아있는지 확인하고, 아니면 안전하게 중단한다.
  SlowTaskProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'slowTaskProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$slowTaskHash();

  @$internal
  @override
  SlowTask create() => SlowTask();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$slowTaskHash() => r'e422456da6336c765ac4887cbe053aa2f0ecfbea';

/// ref.mounted 데모: 느린 비동기 작업 도중 provider 가 폐기될 수 있는 상황.
///
/// autoDispose(기본) provider 라서, 작업(await) 중에 사용자가 화면을 떠나면 폐기된다.
/// await 뒤에 state 를 그대로 갱신하면 "폐기된 provider 를 갱신"하게 되어 위험하다.
/// → ref.mounted 로 아직 살아있는지 확인하고, 아니면 안전하게 중단한다.

abstract class _$SlowTask extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
