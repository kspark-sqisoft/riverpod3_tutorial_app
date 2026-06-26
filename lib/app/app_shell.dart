import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'toc.dart';

/// 앱의 뼈대(셸): 왼쪽 목차 사이드바 + 오른쪽 콘텐츠 영역.
///
/// go_router 의 `ShellRoute` 가 현재 라우트에 해당하는 페이지를 [child] 로 넘겨준다.
/// 사이드바는 그대로 유지되고 [child] 만 교체되므로, 목차를 누르면 콘텐츠만 바뀐다.
/// 화면이 좁으면(<800) 사이드바를 Drawer 로 전환한다(반응형).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child; // 현재 라우트의 페이지(콘텐츠 영역)

  static const double _wideBreakpoint = 800; // 이 너비 이상이면 사이드바 고정 노출

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= _wideBreakpoint;
    // 현재 경로 — 사이드바에서 활성 항목을 하이라이트하는 데 사용
    final currentPath = GoRouterState.of(context).uri.path;

    if (isWide) {
      // 넓은 화면: 사이드바를 항상 보이게 고정
      return Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 300,
              child: _Sidebar(currentPath: currentPath, inDrawer: false),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child), // 콘텐츠 영역
          ],
        ),
      );
    }

    // 좁은 화면: 사이드바를 Drawer 로
    return Scaffold(
      appBar: AppBar(title: const Text('Riverpod 3.3.2 학습')),
      drawer: Drawer(
        child: _Sidebar(currentPath: currentPath, inDrawer: true),
      ),
      body: child,
    );
  }
}

/// 목차 사이드바 본체. [kToc] 데이터에서 섹션/토픽 목록을 생성한다.
class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.currentPath, required this.inDrawer});

  final String currentPath; // 현재 활성 경로
  final bool inDrawer; // Drawer 안에 있으면 탭 후 닫아준다

  // 항목 이동 처리: 경로로 이동하고, Drawer 였다면 닫는다.
  void _go(BuildContext context, String path) {
    context.go(path); // ShellRoute 의 콘텐츠만 교체됨
    if (inDrawer) Navigator.of(context).pop(); // Drawer 닫기
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // 상단 타이틀(겸 홈 이동)
          DrawerHeader(
            decoration: BoxDecoration(color: scheme.primaryContainer),
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () => _go(context, '/'),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.water_drop, color: scheme.onPrimaryContainer),
                    const SizedBox(height: 8),
                    Text('Riverpod 학습 목차',
                        style: TextStyle(
                            color: scheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
          ),
          // 섹션별로 헤더 + 토픽 타일
          for (final section in kToc) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text('${section.code}. ${section.title}',
                  style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ),
            for (final topic in section.topics)
              _TopicTile(
                topic: topic,
                selected: currentPath == topic.path, // 활성 항목 강조
                onTap: () => _go(context, topic.path),
              ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// 사이드바의 토픽 한 줄.
class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.topic,
    required this.selected,
    required this.onTap,
  });

  final TocTopic topic;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      dense: true,
      selected: selected,
      selectedTileColor: scheme.secondaryContainer,
      leading: CircleAvatar(
        radius: 13,
        backgroundColor:
            selected ? scheme.primary : scheme.surfaceContainerHighest,
        child: Text('${topic.number}',
            style: TextStyle(
                fontSize: 11,
                color: selected ? scheme.onPrimary : scheme.onSurfaceVariant)),
      ),
      title: Text(topic.title, style: const TextStyle(fontSize: 13.5)),
      onTap: onTap,
    );
  }
}
