import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider_basics_providers.g.dart';

/// 변경 가능한 기준 값: 가격. (NotifierProvider 로 사용자가 조정)
@riverpod
class Price extends _$Price {
  @override
  double build() => 10000; // 초기 가격 10,000원

  void setPrice(double value) => state = value; // 가격 변경
}

/// 읽기 전용 의존성: 세율(10%). 다른 provider 가 ref.watch 로 주입받는다.
@riverpod
double taxRate(Ref ref) => 0.1;

/// 파생(derived) provider: 가격 × (1 + 세율) = 세금 포함 합계.
///
/// 핵심: 이 provider 는 priceProvider 와 taxRateProvider 를 ref.watch 로 "의존"한다.
/// 둘 중 하나라도 바뀌면 이 build 가 자동으로 다시 실행되어 합계가 갱신된다.
@riverpod
double totalPrice(Ref ref) {
  final price = ref.watch(priceProvider); // 가격 구독
  final tax = ref.watch(taxRateProvider); // 세율 구독
  return price * (1 + tax); // 합성 결과
}
