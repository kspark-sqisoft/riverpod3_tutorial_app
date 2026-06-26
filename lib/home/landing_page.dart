import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/s8_advanced/s8_keepalive_pages/keepalive_pages_providers.dart';

/// 기본 라우트('/')에서 콘텐츠 영역에 표시되는 환영/안내 페이지.
///
/// 왼쪽 목차에서 토픽을 선택하면 이 자리에 해당 학습 페이지가 들어온다.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.water_drop, size: 56, color: scheme.primary),
              const SizedBox(height: 16),
              Text('Riverpod 3.3.2 심화 학습',
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                '왼쪽 목차에서 토픽을 선택하세요. 각 페이지는 '
                '개념 설명 + 라이브 데모 + 예제 코드로 구성됩니다.\n'
                '하단/우측의 실시간 로그로 provider 의 생성·갱신·폐기 흐름을 직접 확인할 수 있습니다.',
                style: textTheme.bodyLarge?.copyWith(height: 1.6),
              ),
              const SizedBox(height: 24),
              Card(
                color: scheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.tips_and_updates,
                          color: scheme.onSecondaryContainer),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'S0 → S8 순서대로 따라가면 기초부터 현업 심화·signals 비교·실전 패턴까지 이어집니다.',
                          style: TextStyle(color: scheme.onSecondaryContainer),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // keepAlive 체감(토픽 38): 토픽 38에서 올린 값이 이 홈 페이지에서도 유지된다.
              Consumer(
                builder: (context, ref, _) {
                  final persistent = ref.watch(persistentCounterProvider);
                  return Card(
                    color: scheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.all_inclusive,
                              color: scheme.onPrimaryContainer),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'keepAlive 카운터(토픽 38) = $persistent  · 페이지를 옮겨도 이 값이 유지됩니다',
                              style:
                                  TextStyle(color: scheme.onPrimaryContainer),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
