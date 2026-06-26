import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import 'provider_basics_providers.dart';

/// 토픽 2: Provider(기본) — 읽기 전용 값, 의존성 주입, 파생(combining) provider.
///
/// 페이지 자체는 StatelessWidget 으로 두고, 값이 자주 바뀌는 데모 영역만 Consumer 로 감싼다.
/// → 슬라이더를 드래그해도 설명/코드 스니펫(SelectableText)은 리빌드되지 않아
///   접근성 트리(AXTree) 요동 같은 부작용과 불필요한 rebuild 를 막는다(범위 좁히기).
class ProviderBasicsPage extends StatelessWidget {
  const ProviderBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '2. Provider (기본)',
      explanation:
          'Provider 는 "읽기 전용 값"을 제공합니다. 값은 다른 provider 를 조합해 만들 수도 '
          '있는데, build 안에서 ref.watch 로 다른 provider 를 구독하면 그 값이 바뀔 때 '
          '자동으로 다시 계산됩니다. 이렇게 "provider 가 provider 에 의존"하는 것이 '
          'Riverpod 의 의존성 주입(DI)·파생 상태의 핵심입니다.',
      points: const [
        'totalPrice 는 price 와 taxRate 에 의존하는 파생 provider',
        'price 를 바꾸면 totalPrice 가 자동 재계산된다(수동 갱신 불필요)',
        'taxRate 처럼 읽기 전용 의존성을 주입해 결합도를 낮춘다',
        '값이 바뀌는 부분만 Consumer 로 감싸 rebuild 범위를 좁힌다',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Consumer: 이 안에서만 provider 를 watch → 가격 변경 시 이 영역만 rebuild
          child: Consumer(
            builder: (context, ref, _) {
              final price = ref.watch(priceProvider);
              final tax = ref.watch(taxRateProvider);
              final total = ref.watch(totalPriceProvider); // 파생값(자동 계산)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row('가격(price)', '${price.toStringAsFixed(0)} 원'),
                  _row('세율(taxRate)', '${(tax * 100).toStringAsFixed(0)} %'),
                  const Divider(),
                  _row('합계(totalPrice, 파생)', '${total.toStringAsFixed(0)} 원',
                      emphasize: true),
                  const SizedBox(height: 12),
                  Text('가격 조절 → 합계 자동 갱신',
                      style: Theme.of(context).textTheme.bodySmall),
                  Slider(
                    value: price,
                    min: 0,
                    max: 100000,
                    divisions: 20,
                    label: price.toStringAsFixed(0),
                    // read: 슬라이더 변경 시 notifier 의 setPrice 호출
                    onChanged: (v) =>
                        ref.read(priceProvider.notifier).setPrice(v),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'provider_basics_providers.dart', code: _code),
      ],
    );
  }

  // 라벨-값 한 줄 위젯(간단 헬퍼)
  Widget _row(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style: TextStyle(
                  fontWeight: emphasize ? FontWeight.bold : FontWeight.normal,
                  fontSize: emphasize ? 18 : 14)),
        ],
      ),
    );
  }
}

const String _code = r'''
@riverpod
class Price extends _$Price {
  @override
  double build() => 10000;
  void setPrice(double v) => state = v;
}

@riverpod
double taxRate(Ref ref) => 0.1; // 주입되는 읽기 전용 의존성

@riverpod
double totalPrice(Ref ref) {
  final price = ref.watch(priceProvider);   // 의존 1
  final tax = ref.watch(taxRateProvider);   // 의존 2
  return price * (1 + tax);                 // 둘 중 하나만 바뀌어도 자동 재계산
}
''';
