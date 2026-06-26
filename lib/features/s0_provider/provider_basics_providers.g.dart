// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_basics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 변경 가능한 기준 값: 가격. (NotifierProvider 로 사용자가 조정)

@ProviderFor(Price)
final priceProvider = PriceProvider._();

/// 변경 가능한 기준 값: 가격. (NotifierProvider 로 사용자가 조정)
final class PriceProvider extends $NotifierProvider<Price, double> {
  /// 변경 가능한 기준 값: 가격. (NotifierProvider 로 사용자가 조정)
  PriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'priceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$priceHash();

  @$internal
  @override
  Price create() => Price();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$priceHash() => r'8aa2c9077c685ad0f65a5343b6de8c39a63d28e5';

/// 변경 가능한 기준 값: 가격. (NotifierProvider 로 사용자가 조정)

abstract class _$Price extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 읽기 전용 의존성: 세율(10%). 다른 provider 가 ref.watch 로 주입받는다.

@ProviderFor(taxRate)
final taxRateProvider = TaxRateProvider._();

/// 읽기 전용 의존성: 세율(10%). 다른 provider 가 ref.watch 로 주입받는다.

final class TaxRateProvider extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// 읽기 전용 의존성: 세율(10%). 다른 provider 가 ref.watch 로 주입받는다.
  TaxRateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taxRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taxRateHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return taxRate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$taxRateHash() => r'd361b2de42ead621f4d4bdac728ef745f0b2731b';

/// 파생(derived) provider: 가격 × (1 + 세율) = 세금 포함 합계.
///
/// 핵심: 이 provider 는 priceProvider 와 taxRateProvider 를 ref.watch 로 "의존"한다.
/// 둘 중 하나라도 바뀌면 이 build 가 자동으로 다시 실행되어 합계가 갱신된다.

@ProviderFor(totalPrice)
final totalPriceProvider = TotalPriceProvider._();

/// 파생(derived) provider: 가격 × (1 + 세율) = 세금 포함 합계.
///
/// 핵심: 이 provider 는 priceProvider 와 taxRateProvider 를 ref.watch 로 "의존"한다.
/// 둘 중 하나라도 바뀌면 이 build 가 자동으로 다시 실행되어 합계가 갱신된다.

final class TotalPriceProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// 파생(derived) provider: 가격 × (1 + 세율) = 세금 포함 합계.
  ///
  /// 핵심: 이 provider 는 priceProvider 와 taxRateProvider 를 ref.watch 로 "의존"한다.
  /// 둘 중 하나라도 바뀌면 이 build 가 자동으로 다시 실행되어 합계가 갱신된다.
  TotalPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalPriceHash();

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    return totalPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$totalPriceHash() => r'a99f84d06d60bf599e76ce296572eeb79b7a0c7e';
