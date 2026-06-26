import 'package:flutter/material.dart';

import 'code_snippet.dart';
import 'explanation_card.dart';

/// 모든 토픽 페이지의 공통 레이아웃 템플릿.
///
/// 위에서 아래로:  제목 → [ExplanationCard] 개념 설명 → 라이브 데모 → 코드 스니펫(들).
/// 데스크톱에서 너무 넓게 퍼지지 않도록 본문 최대 너비를 제한한다.
class ConceptPage extends StatelessWidget {
  const ConceptPage({
    super.key,
    required this.title,
    required this.explanation,
    required this.demo,
    this.points = const <String>[],
    this.snippets = const <CodeSnippet>[],
  });

  final String title; // 페이지 제목
  final String explanation; // 개념 설명 본문(한국어)
  final List<String> points; // 핵심 요점(불릿)
  final Widget demo; // 라이브 데모 영역
  final List<CodeSnippet> snippets; // 하단 코드 스니펫(들)

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900), // 본문 가독 폭 제한
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 제목
            Text(title, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // 개념 설명
            ExplanationCard(body: explanation, points: points),
            const SizedBox(height: 24),
            // 데모 섹션
            _SectionLabel(icon: Icons.play_circle, label: '라이브 데모'),
            const SizedBox(height: 8),
            demo,
            // 코드 섹션(있을 때만)
            if (snippets.isNotEmpty) ...[
              const SizedBox(height: 24),
              _SectionLabel(icon: Icons.code, label: '예제 코드'),
              const SizedBox(height: 8),
              for (final s in snippets) ...[
                s,
                const SizedBox(height: 12),
              ],
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// 섹션 구분용 작은 라벨(데모/코드).
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: scheme.primary),
        const SizedBox(width: 8),
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: scheme.primary)),
      ],
    );
  }
}
