import 'package:flutter/material.dart';

import 'app_logger.dart';

// LogFilter.test 의 인자 타입이 LogEntry 라, 이 위젯/LogFilter 를 쓰는 쪽이
// 별도 import 없이 LogEntry 를 참조할 수 있도록 함께 노출한다.
export 'app_logger.dart' show LogEntry;

/// 로그를 "출처"별로 거르기 위한 필터 한 개.
///
/// [label] 은 칩에 표시할 이름, [test] 는 해당 로그 항목을 보여줄지 판정하는 술어다.
/// 예) 토픽 12 의 ① family 인자 / ② 내부 watch 처럼 한 화면에 섞여 찍히는 로그를
/// 한쪽만 골라 보고 싶을 때 [LifecycleLogView.filters] 로 넘긴다.
@immutable
class LogFilter {
  const LogFilter({required this.label, required this.test});

  final String label; // 필터 칩에 표시할 이름
  final bool Function(LogEntry entry) test; // 이 항목을 보여줄지 판정
}

/// [AppLogger.entries] 를 실시간으로 보여주는 로그 패널.
///
/// ValueListenableBuilder 로 로그 버퍼를 구독하므로, provider 라이프사이클/상태전이가
/// 일어날 때마다 자동으로 갱신된다. riverpod 과 무관한 순수 위젯이라 어디서든 재사용 가능.
///
/// [filters] 를 넘기면 헤더 아래에 "전체 + 각 필터" 칩이 생겨, 섞여 찍히는 로그를
/// 한 출처만 골라 볼 수 있다(기본은 빈 목록 → 칩 없이 전체만 표시, 기존 동작과 동일).
class LifecycleLogView extends StatefulWidget {
  const LifecycleLogView({
    super.key,
    this.height = 220,
    this.filters = const <LogFilter>[],
  });

  final double height; // 로그 패널 높이
  final List<LogFilter> filters; // 출처 필터(비어 있으면 칩 미표시)

  @override
  State<LifecycleLogView> createState() => _LifecycleLogViewState();
}

class _LifecycleLogViewState extends State<LifecycleLogView> {
  // 선택된 필터 인덱스. null 이면 '전체'(필터 없이 모두 표시).
  int? _selected;

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
    final filters = widget.filters;
    // 선택된 필터(없으면 null → 전체).
    final LogFilter? active =
        _selected == null ? null : filters[_selected!];

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
          // 필터 칩 줄: filters 가 주어졌을 때만. '전체' + 각 출처를 골라 본다.
          if (filters.isNotEmpty)
            Container(
              color: scheme.surfaceContainerHigh,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('전체'),
                    visualDensity: VisualDensity.compact,
                    selected: _selected == null,
                    onSelected: (_) => setState(() => _selected = null),
                  ),
                  for (var i = 0; i < filters.length; i++)
                    ChoiceChip(
                      label: Text(filters[i].label),
                      visualDensity: VisualDensity.compact,
                      selected: _selected == i,
                      onSelected: (_) => setState(() => _selected = i),
                    ),
                ],
              ),
            ),
          // 본문: 로그 버퍼를 구독해 리스트로 표시(선택된 필터로 거른다)
          SizedBox(
            height: widget.height,
            child: ValueListenableBuilder<List<LogEntry>>(
              valueListenable: log.entries, // 로그가 바뀔 때마다 이 영역만 다시 그림
              builder: (context, entries, _) {
                // 선택된 필터가 있으면 해당 출처만 남긴다.
                final shown = active == null
                    ? entries
                    : entries
                        .where(active.test)
                        .toList(growable: false);
                if (shown.isEmpty) {
                  return Center(
                    child: Text(
                      active == null
                          ? '아직 로그가 없습니다. 데모를 조작해 보세요.'
                          : '이 필터에 해당하는 로그가 없습니다.',
                    ),
                  );
                }
                return ListView.builder(
                  reverse: true, // 최신 로그가 아래쪽(스크롤 끝)에 보이도록
                  padding: const EdgeInsets.all(8),
                  itemCount: shown.length,
                  itemBuilder: (context, index) {
                    // reverse 이므로 뒤에서부터 꺼내 최신이 아래로 가게 함
                    final e = shown[shown.length - 1 - index];
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
