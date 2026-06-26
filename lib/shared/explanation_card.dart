import 'package:flutter/material.dart';

/// 토픽 상단에 놓이는 한국어 개념 설명 카드.
///
/// [body] 는 본문 설명, [points] 는 핵심 요점(불릿)으로 선택 표시한다.
class ExplanationCard extends StatelessWidget {
  const ExplanationCard({
    super.key,
    required this.body,
    this.points = const <String>[],
  });

  final String body; // 개념 본문 설명
  final List<String> points; // 핵심 요점(선택)

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 라벨
            Row(
              children: [
                Icon(Icons.menu_book, size: 18, color: scheme.onSecondaryContainer),
                const SizedBox(width: 8),
                Text('개념 설명',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSecondaryContainer)),
              ],
            ),
            const SizedBox(height: 8),
            // 본문
            Text(body,
                style: TextStyle(height: 1.5, color: scheme.onSecondaryContainer)),
            // 요점 불릿(있을 때만)
            if (points.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final p in points)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ',
                          style: TextStyle(color: scheme.onSecondaryContainer)),
                      Expanded(
                        child: Text(p,
                            style: TextStyle(
                                height: 1.4, color: scheme.onSecondaryContainer)),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
