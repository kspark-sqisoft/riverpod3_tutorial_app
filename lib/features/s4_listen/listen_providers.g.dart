// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listen_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 사이드이펙트 데모용 카운터.

@ProviderFor(EventCounter)
final eventCounterProvider = EventCounterProvider._();

/// 사이드이펙트 데모용 카운터.
final class EventCounterProvider extends $NotifierProvider<EventCounter, int> {
  /// 사이드이펙트 데모용 카운터.
  EventCounterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventCounterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventCounterHash();

  @$internal
  @override
  EventCounter create() => EventCounter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$eventCounterHash() => r'346f84ef0ef2249fe3a10a03a808febc638da11b';

/// 사이드이펙트 데모용 카운터.

abstract class _$EventCounter extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
