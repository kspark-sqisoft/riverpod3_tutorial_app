// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// SQLite 저장소를 여는 provider. 앱 전체가 공유하므로 keepAlive.
/// (데스크톱은 main 에서 ffi 초기화가 되어 있어야 동작한다.)

@ProviderFor(storage)
final storageProvider = StorageProvider._();

/// SQLite 저장소를 여는 provider. 앱 전체가 공유하므로 keepAlive.
/// (데스크톱은 main 에서 ffi 초기화가 되어 있어야 동작한다.)

final class StorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<JsonSqFliteStorage>,
          JsonSqFliteStorage,
          FutureOr<JsonSqFliteStorage>
        >
    with
        $FutureModifier<JsonSqFliteStorage>,
        $FutureProvider<JsonSqFliteStorage> {
  /// SQLite 저장소를 여는 provider. 앱 전체가 공유하므로 keepAlive.
  /// (데스크톱은 main 에서 ffi 초기화가 되어 있어야 동작한다.)
  StorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageHash();

  @$internal
  @override
  $FutureProviderElement<JsonSqFliteStorage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JsonSqFliteStorage> create(Ref ref) {
    return storage(ref);
  }
}

String _$storageHash() => r'7cb63511f4ce6a68b8b0076bdf12988f84b0ccae';

/// 영속화되는 카운터. 앱을 껐다 켜도 값이 복원된다.

@ProviderFor(PersistedCounter)
final persistedCounterProvider = PersistedCounterProvider._();

/// 영속화되는 카운터. 앱을 껐다 켜도 값이 복원된다.
final class PersistedCounterProvider
    extends $AsyncNotifierProvider<PersistedCounter, int> {
  /// 영속화되는 카운터. 앱을 껐다 켜도 값이 복원된다.
  PersistedCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'persistedCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$persistedCounterHash();

  @$internal
  @override
  PersistedCounter create() => PersistedCounter();
}

String _$persistedCounterHash() => r'71c7bc6b29eede732877b77f54a3c0be1d34a7de';

/// 영속화되는 카운터. 앱을 껐다 켜도 값이 복원된다.

abstract class _$PersistedCounter extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
