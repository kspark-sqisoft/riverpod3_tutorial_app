import 'package:flutter/material.dart';

import 'app_logger.dart';

/// [AppLogger.entries] 를 실시간으로 보여주는 로그 패널.
///
/// ValueListenableBuilder 로 로그 버퍼를 구독하므로, provider 라이프사이클/상태전이가
/// 일어날 때마다 자동으로 갱신된다. riverpod 과 무관한 순수 위젯이라 어디서든 재사용 가능.
class LifecycleLogView extends StatelessWidget {
  const LifecycleLogView({super.key, this.height = 220});

  final double height; // 로그 패널 높이

  // 로그 레벨별 색상(가독성).
  Color _color(LogTag tag, ColorScheme scheme) => switch (tag) {
        LogTag.trace => scheme.outline,
        LogTag.debug => scheme.primary,
        LogTag.info => scheme.tertiary,
        LogTag.warning => Colors.orange.shade800,
        LogTag.error => scheme.error,
      };

  // HH:mm:ss.SSS 형태로 시각 포맷(외부 패키지 없이 직접).
  String _time(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    String three(int n) => n.toString().padLeft(3, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}.${three(t.millisecond)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 헤더: 제목 + 비우기 버튼
          Container(
            color: scheme.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.terminal, size: 18, color: scheme.onSurfaceVariant),
                const SizedBox(width: 8),
                const Text('실시간 로그', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                // 로그 비우기: AppLogger 의 버퍼를 초기화
                TextButton.icon(
                  onPressed: log.clear,
                  icon: const Icon(Icons.delete_sweep, size: 18),
                  label: const Text('비우기'),
                ),
              ],
            ),
          ),
          // 본문: 로그 버퍼를 구독해 리스트로 표시
          SizedBox(
            height: height,
            child: ValueListenableBuilder<List<LogEntry>>(
              valueListenable: log.entries, // 로그가 바뀔 때마다 이 영역만 다시 그림
              builder: (context, entries, _) {
                if (entries.isEmpty) {
                  return const Center(
                    child: Text('아직 로그가 없습니다. 데모를 조작해 보세요.'),
                  );
                }
                return ListView.builder(
                  reverse: true, // 최신 로그가 아래쪽(스크롤 끝)에 보이도록
                  padding: const EdgeInsets.all(8),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    // reverse 이므로 뒤에서부터 꺼내 최신이 아래로 가게 함
                    final e = entries[entries.length - 1 - index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '${_time(e.time)}  ',
                            style: TextStyle(color: scheme.outline, fontSize: 11),
                          ),
                          TextSpan(
                            text: e.message,
                            style: TextStyle(color: _color(e.tag, scheme)),
                          ),
                        ]),
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
