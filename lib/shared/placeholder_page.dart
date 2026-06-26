import 'package:flutter/material.dart';

/// 아직 구현되지 않은 토픽을 위한 임시 페이지.
///
/// 단계적 구현 동안 사이드바 목차는 모두 노출하되, 미구현 토픽은 이 페이지로 연결한다.
/// (해당 단계에서 실제 페이지로 교체된다.)
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.construction, size: 48, color: scheme.outline),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 4),
          Text('이 토픽은 곧 추가됩니다.',
              style: TextStyle(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
