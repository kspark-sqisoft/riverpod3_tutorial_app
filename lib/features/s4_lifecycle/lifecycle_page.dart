import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'lifecycle_providers.dart';

/// 토픽 11: 프로바이더 라이프사이클 콜백.
///
/// 같은 콜백을 단 두 provider 를 위(autoDispose)·아래(keepAlive) 두 섹션으로 나눠,
/// 각 섹션의 독립 구독 스위치로 onAddListener/onRemoveListener/onCancel/onResume/onDispose 를 비교한다.
/// 특히 "구독을 모두 끈" 순간 autoDispose 는 폐기되고 keepAlive 는 유지된다.
/// 각 섹션의 '상태 변경'은 콜백 없이 알림만, '무효화'는 onDispose 를 직접 유발한다.
class LifecyclePage extends ConsumerWidget {
  const LifecyclePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConceptPage(
      title: '11. 프로바이더 라이프사이클 콜백',
      explanation:
          '프로바이더는 Uninitialized → Alive → (Paused) → Disposed 의 생애를 가집니다. '
          '이 페이지는 같은 콜백을 단 두 provider 를 위(autoDispose)·아래(keepAlive) 두 섹션으로 나눠, '
          '각각 독립된 구독 스위치로 비교합니다. 어느 쪽이든 첫 구독에서 build(Alive), '
          '리스너 증감마다 onAddListener/onRemoveListener 가 찍힙니다. '
          '결정적 차이는 "구독을 모두 끈" 순간입니다: 위 autoDispose 는 onCancel → onDispose 로 실제 폐기되어 '
          '다시 켜면 build 가 재실행되고("생성 @시각" 갱신), 아래 keepAlive 는 onCancel(Paused)까지만 가고 '
          '폐기되지 않아 다시 켜면 onResume 으로 같은 인스턴스가 살아납니다("생성 @시각" 유지). '
          '각 섹션의 "상태 변경"은 콜백 없이 알림만, "무효화"는 onDispose 후 재build 합니다.',
      points: const [
        'autoDispose(위): 구독 0 → onCancel → onDispose 폐기 → 재구독 시 build 재실행(생성시각 갱신)',
        'keepAlive(아래): 구독 0 → onCancel(Paused)까지, 폐기 안 됨 → 재구독 onResume(생성시각 유지)',
        'onAddListener / onRemoveListener: 두 섹션 공통, 구독이 늘고 줄 때',
        '상태 변경(state=): 라이프사이클 콜백 없이 알림만 (같은 인스턴스 유지)',
        'invalidate: onDispose → build 재실행',
        '비교 팁: 두 섹션의 스위치를 모두 끄고 로그의 [lifecycleDemoAutoProvider] vs [lifecycleDemoProvider] 차이를 보세요',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 위 섹션: autoDispose ──
          _LifecycleSection(
            title: '① autoDispose — @riverpod',
            subtitle: '구독을 모두 끄면 onCancel → onDispose 로 폐기됩니다. '
                '다시 켜면 build 가 재실행되어 "생성 @시각"이 갱신됩니다.',
            accent: Colors.deepOrange,
            watch: (ref) => ref.watch(lifecycleDemoAutoProvider),
            onBump: (ref) => ref.read(lifecycleDemoAutoProvider.notifier).bump(),
            onInvalidate: (ref) => ref.invalidate(lifecycleDemoAutoProvider),
          ),
          const SizedBox(height: 12),
          // ── 아래 섹션: keepAlive ──
          _LifecycleSection(
            title: '② keepAlive — @Riverpod(keepAlive: true)',
            subtitle: '구독을 모두 꺼도 onCancel(Paused)까지만 — 폐기되지 않습니다. '
                '다시 켜면 onResume 으로 같은 인스턴스가 살아나 "생성 @시각"이 유지됩니다.',
            accent: Colors.green,
            watch: (ref) => ref.watch(lifecycleDemoProvider),
            onBump: (ref) => ref.read(lifecycleDemoProvider.notifier).bump(),
            onInvalidate: (ref) => ref.invalidate(lifecycleDemoProvider),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 220),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'lifecycle_providers.dart', code: _code),
      ],
    );
  }
}

/// 한 provider 에 대한 독립 비교 섹션 — 자체 구독 스위치/표시/버튼을 가진다.
class _LifecycleSection extends ConsumerStatefulWidget {
  const _LifecycleSection({
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.watch,
    required this.onBump,
    required this.onInvalidate,
  });

  final String title;
  final String subtitle;
  final Color accent;
  final DemoState Function(WidgetRef ref) watch; // 값 watch (구체 provider 캡처)
  final void Function(WidgetRef ref) onBump; // 상태 변경
  final void Function(WidgetRef ref) onInvalidate; // 무효화

  @override
  ConsumerState<_LifecycleSection> createState() => _LifecycleSectionState();
}

class _LifecycleSectionState extends ConsumerState<_LifecycleSection> {
  bool _subA = false; // 이 섹션의 구독 A on/off
  bool _subB = false; // 이 섹션의 구독 B on/off

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: widget.accent,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 2),
            Text(widget.subtitle,
                style: Theme.of(context).textTheme.bodySmall),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('구독 A'),
              value: _subA,
              onChanged: (v) => setState(() => _subA = v),
            ),
            SwitchListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('구독 B'),
              value: _subB,
              onChanged: (v) => setState(() => _subB = v),
            ),
            // 구독이 켜진 만큼 watcher 위젯을 띄운다(각 watcher = 리스너 1개).
            if (_subA) _SectionWatcher(label: 'A', watch: widget.watch),
            if (_subB) _SectionWatcher(label: 'B', watch: widget.watch),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    // 상태만 변경 → 콜백 없이 리스너에 알림만
                    onPressed: () => widget.onBump(ref),
                    icon: const Icon(Icons.add),
                    label: const Text('상태 변경'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    // 무효화 → onDispose 유발 후 재build
                    onPressed: () => widget.onInvalidate(ref),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('무효화'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// provider 를 watch 하는 작은 위젯 = 리스너 1개. 표시되면 구독, 사라지면 구독 해제.
class _SectionWatcher extends ConsumerWidget {
  const _SectionWatcher({required this.label, required this.watch});
  final String label;
  final DemoState Function(WidgetRef ref) watch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (count, createdAt) = watch(ref); // (카운트, 생성시각)
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.visibility),
      title: Text('구독 $label · 생성 @$createdAt'),
      // '상태 변경' 으로 올라가는 간단한 카운트 값을 배지로 표시.
      trailing: Chip(
        visualDensity: VisualDensity.compact,
        label: Text('카운트 $count'),
      ),
    );
  }
}

const String _code = r'''
// 상태 = (카운트, 생성시각). 카운트는 '상태 변경' 으로 +1 되는 간단한 값.
typedef DemoState = (int count, String createdAt);

@Riverpod(keepAlive: true)            // 폐기되지 않음
class LifecycleDemo extends _$LifecycleDemo {
  int _count = 0;
  String _createdAt = '';

  @override
  DemoState build() {
    _count = 0;
    _createdAt = nowHHmmss();
    ref.onCancel(()  => log('Paused: 마지막 리스너 사라짐'));
    ref.onResume(()  => log('Alive: 다시 구독'));
    ref.onDispose(() => log('Disposed: 폐기'));   // 무효화로만 발생
    return (_count, _createdAt);
  }
  // 상태만 변경 — 카운트만 +1 (build·onDispose 없이 알림만)
  void bump() => state = (++_count, _createdAt);
}

@riverpod                              // autoDispose(기본): 구독 0 이면 폐기
class LifecycleDemoAuto extends _$LifecycleDemoAuto {
  // ... 위와 동일하지만 구독 0 이면 onCancel → onDispose 로 폐기된다.
}
''';
