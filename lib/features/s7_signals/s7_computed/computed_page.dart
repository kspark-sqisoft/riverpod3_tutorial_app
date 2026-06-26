import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';

final _price = signal(10000.0); // 기준 값
final _taxRate = signal(0.1); // 세율
// computed: 다른 signal 들을 읽어 파생값을 만든다. 읽은 signal 이 바뀌면 자동 재계산.
final _total = computed(() => _price.value * (1 + _taxRate.value));

/// 토픽 26: computed — 파생/합성 상태. (Riverpod 파생 Provider / select 에 대응)
class ComputedPage extends StatelessWidget {
  const ComputedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '26. computed (파생)',
      explanation:
          'computed(() => ...) 는 다른 signal 을 조합해 파생값을 만듭니다. 콜백에서 읽은 signal 이 '
          '바뀌면 자동으로 다시 계산되고, 값이 같으면 알리지 않습니다(메모이즈). Riverpod 의 '
          '"파생 Provider(ref.watch 로 합성)"나 select 와 같은 역할을, 별도 API 없이 함수 하나로 '
          '표현합니다. signals 는 의존성을 자동 추적하므로 select 를 따로 쓸 필요가 거의 없습니다.',
      points: const [
        'computed: 읽은 signal 자동 추적 → 변경 시 자동 재계산',
        '값이 동일하면 구독자에게 알리지 않음(불필요 rebuild 방지 = select 효과)',
        'Riverpod 파생 Provider / select 에 대응',
      ],
      demo: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 세 값을 Watch 로 표시 — total 은 price/tax 변경 시 자동 갱신
              SignalBuilder(builder:(context) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('가격: ${_price.value.toStringAsFixed(0)} 원'),
                      Text('세율: ${(_taxRate.value * 100).toStringAsFixed(0)} %'),
                      const Divider(),
                      Text('합계(computed): ${_total.value.toStringAsFixed(0)} 원',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  )),
              const SizedBox(height: 8),
              const Text('가격 조절 → 합계 자동 갱신'),
              SignalBuilder(builder:(context) => Slider(
                    value: _price.value,
                    min: 0,
                    max: 100000,
                    divisions: 20,
                    label: _price.value.toStringAsFixed(0),
                    onChanged: (v) => _price.value = v, // signal 직접 변경
                  )),
            ],
          ),
        ),
      ),
      snippets: const [
        CodeSnippet(title: 'signals', code: _signalsCode),
        CodeSnippet(title: 'Riverpod (대응)', code: _riverpodCode),
      ],
    );
  }
}

const String _signalsCode = r'''
final price = signal(10000.0);
final taxRate = signal(0.1);
// 읽은 signal 자동 추적 → 바뀌면 자동 재계산
final total = computed(() => price.value * (1 + taxRate.value));
''';

const String _riverpodCode = r'''
@riverpod double price(Ref ref) => 10000;   // (또는 Notifier)
@riverpod double taxRate(Ref ref) => 0.1;
@riverpod double total(Ref ref) =>
    ref.watch(priceProvider) * (1 + ref.watch(taxRateProvider));
''';
