import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 클립보드 복사용

/// 화면 하단에 예제 소스 코드를 보여주는 스니펫 박스.
///
/// 학습 규약: 여기 표시하는 코드는 실제 파일 코드(주석 포함)와 동일하게 유지한다.
/// (지금은 monospace 박스 + 복사 버튼. 필요 시 flutter_highlight 로 색상 강조 가능.)
class CodeSnippet extends StatelessWidget {
  const CodeSnippet({super.key, required this.code, this.title = 'code'});

  final String code; // 표시할 소스 코드 문자열
  final String title; // 헤더 라벨(예: 파일명/설명)

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      color: scheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더: 제목 + 복사 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
            child: Row(
              children: [
                Icon(Icons.code, size: 18, color: scheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  tooltip: '복사',
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {
                    // 코드 전체를 클립보드로 복사하고 스낵바로 알림
                    Clipboard.setData(ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('코드를 복사했습니다.')),
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // 본문: 가로 스크롤 가능한 monospace 코드
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(12),
            child: SelectableText(
              code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12.5, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
