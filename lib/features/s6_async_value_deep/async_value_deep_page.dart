import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/app_logger.dart';
import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'async_value_deep_providers.dart';

/// 토픽 21: AsyncValue 심화 — 플래그(isLoading/isReloading/isRefreshing/hasValue/hasError)와
/// when() 의 skip 옵션(skipLoadingOnReload/Refresh/Error)을 직접 토글하며 차이를 본다.
class AsyncValueDeepPage extends ConsumerStatefulWidget {
  const AsyncValueDeepPage({super.key});

  @override
  ConsumerState<AsyncValueDeepPage> createState() => _AsyncValueDeepPageState();
}

class _AsyncValueDeepPageState extends ConsumerState<AsyncValueDeepPage> {
  // when() 에 넘길 skip 옵션 — 라이브러리 기본값과 동일하게 시작한다.
  bool _skipLoadingOnReload = false; // 기본 false
  bool _skipLoadingOnRefresh = true; // 기본 true
  bool _skipError = false; // 기본 false

  // AsyncValue 의 상태 플래그를 한 줄로.
  String _flags(AsyncValue<Object?> v) =>
      'isLoading=${v.isLoading} · isReloading=${v.isReloading} · '
      'isRefreshing=${v.isRefreshing} · hasValue=${v.hasValue} · '
      'hasError=${v.hasError}';

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(demoDataProvider);
    final fail = ref.watch(failNextProvider);

    // 상태가 바뀔 때마다 플래그를 로그로 — "실시간으로 어떻게 변하는지" 본다.
    ref.listen(demoDataProvider, (prev, next) {
      log.d('📊 [AsyncValue] ${_flags(next)}');
    });

    return ConceptPage(
      title: '21. AsyncValue 심화',
      explanation:
          'AsyncValue 는 data/loading/error 세 갈래지만, "동시에 여러 상태"일 수 있습니다 — 새로고침 중에는 '
          'isLoading 이 true 이면서도 이전 value(hasValue)가 그대로 남아 있습니다. 그래서 플래그로 상황을 더 잘게 '
          '구분합니다. ▷ isReloading: 이전 값이 있는데 "의존(ref.watch) 변경"으로 재계산 중. ▷ isRefreshing: 이전 값이 '
          '있는데 "invalidate/refresh"로 재계산 중. ▷ hasValue/hasError: 값/에러 보유 여부(로딩과 동시 가능). '
          '▷ value(없으면 null) / requireValue(없으면 예외) / isFromCache(영속성 복원) / retrying(자동 재시도 대기). '
          'when() 은 "재요청 중 스피너 깜빡임"을 세 옵션으로 제어합니다 — skipLoadingOnRefresh(기본 true)는 refresh 때 '
          'loading() 을 건너뛰고 이전 data 를, skipLoadingOnReload(기본 false)는 의존 변경 때 기본은 loading() 을 '
          '부르지만 true 면 이전 data 를, skipError(기본 false)는 에러라도 이전 value 가 있으면 data() 로 그립니다. '
          '아래에서 세 옵션을 토글하고 "새로고침/의존 변경/실패" 를 눌러 when() 결과가 어떻게 달라지는지, 그리고 '
          '플래그가 실시간 로그에서 어떻게 변하는지 직접 보세요. '
          '이 옵션들이 왜 있냐면 — "같은 재요청이라도 상황에 따라 사용자에게 보여줄 게 다르기 때문"입니다. '
          '아래 "실전 가이드" 카드에 각 옵션을 실제 어떤 화면에서 쓰는지 정리했습니다.',
      points: const [
        'isLoading: 새 값 로딩 중(최초·watch·refresh 모두). hasValue/hasError 와 동시 가능',
        'isReloading: 이전 값 보유 + 의존(ref.watch) 변경 재계산 (AsyncLoading 인스턴스)',
        'isRefreshing: 이전 값 보유 + invalidate/refresh 재계산 (AsyncData/Error 인스턴스)',
        'value(nullable) / requireValue(없으면 예외) / isFromCache / retrying',
        'when(skipLoadingOnRefresh: 기본 true): refresh 때 loading 건너뛰고 이전 data 유지',
        'when(skipLoadingOnReload: 기본 false): 의존 변경 때 기본은 loading → true 면 이전 data',
        'when(skipError: 기본 false): 에러라도 이전 value 있으면 data 로 표시',
        '실전: 당겨서 새로고침/재시도 → skipLoadingOnRefresh=true(기본)로 목록 유지(깜빡임 X)',
        '실전: 필터·탭·대상(id) 변경(watch) → 기본 false 로 스피너(옛 데이터는 새 조건과 안 맞음)',
        '실전: 대시보드/피드처럼 마지막 데이터 유지 → skipError=true(에러는 토스트/배지로)',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ① 실시간 플래그
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('실시간 플래그',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 4),
                  Text(_flags(async),
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12)),
                  Text('value=${async.value ?? '(없음)'}',
                      style: const TextStyle(
                          fontFamily: 'monospace', fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ② when() 결과 — 토글/트리거에 따라 어느 콜백이 불리는지 박스로 표시
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('when() 결과 (지금 옵션 기준)',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  async.when(
                    skipLoadingOnReload: _skipLoadingOnReload,
                    skipLoadingOnRefresh: _skipLoadingOnRefresh,
                    skipError: _skipError,
                    data: (d) => const _Branch(
                        color: Colors.green,
                        icon: Icons.check_circle,
                        label: 'data()'),
                    loading: () => const _Branch(
                        color: Colors.blue,
                        icon: Icons.hourglass_top,
                        label: 'loading()'),
                    error: (e, _) => const _Branch(
                        color: Colors.red,
                        icon: Icons.error,
                        label: 'error()'),
                  ),
                  const SizedBox(height: 6),
                  Text(async.maybeWhen(
                    skipLoadingOnReload: _skipLoadingOnReload,
                    skipLoadingOnRefresh: _skipLoadingOnRefresh,
                    skipError: _skipError,
                    data: (d) => '→ 데이터 표시: $d',
                    error: (e, _) => '→ 에러 표시: $e',
                    orElse: () => '→ 로딩 표시(스피너)',
                  ), style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ③ skip 옵션 토글
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                children: [
                  _OptionSwitch(
                    label: 'skipLoadingOnRefresh (기본 true)',
                    sub: 'refresh/invalidate 때 loading() 건너뛰고 이전 data',
                    value: _skipLoadingOnRefresh,
                    onChanged: (v) => setState(() => _skipLoadingOnRefresh = v),
                  ),
                  _OptionSwitch(
                    label: 'skipLoadingOnReload (기본 false)',
                    sub: '의존(watch) 변경 때 loading() 건너뛸지',
                    value: _skipLoadingOnReload,
                    onChanged: (v) => setState(() => _skipLoadingOnReload = v),
                  ),
                  _OptionSwitch(
                    label: 'skipError (기본 false)',
                    sub: '에러라도 이전 value 있으면 data() 로',
                    value: _skipError,
                    onChanged: (v) => setState(() => _skipError = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // 실전 가이드: 각 옵션을 실제 어떤 화면에서 왜 쓰는지
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('실전 가이드 — 왜 / 언제 쓰나',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 6),
                  Text(
                    '• skipLoadingOnRefresh=true(기본): 당겨서 새로고침 · 재시도 버튼 · 주기적 갱신. '
                    '보던 목록을 유지한 채 조용히 갱신해 전체 스피너로 깜빡이지 않게 한다 — 거의 항상 이대로.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• skipLoadingOnReload=false(기본): 필터·탭·대상(id) 변경처럼 watch 의존이 바뀐 경우. '
                    '옛 데이터는 새 조건과 안 맞으니 스피너를 보여 혼동을 막는다(예: 사용자 A→B 목록 전환). '
                    '연속성이 더 중요하면 true 로.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '• skipError=true: 대시보드·피드처럼 "마지막 정상 데이터"를 계속 보여주고 싶을 때. '
                    '갱신이 실패해도 화면을 비우지 않고, 에러는 토스트/배지로만 알린다. '
                    '기본(false)은 에러 화면을 표시.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          // ④ 트리거
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                // invalidate → isRefreshing 으로 재계산
                onPressed: () => ref.invalidate(demoDataProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('새로고침 (isRefreshing)'),
              ),
              FilledButton.tonalIcon(
                // 의존(watch) 변경 → isReloading 으로 재계산
                onPressed: () => ref.read(reloadSeedProvider.notifier).bump(),
                icon: const Icon(Icons.link, size: 18),
                label: const Text('의존 변경 (isReloading)'),
              ),
              FilterChip(
                avatar: Icon(fail ? Icons.bug_report : Icons.bug_report_outlined,
                    size: 18),
                label: const Text('다음 요청 실패'),
                selected: fail,
                onSelected: (v) =>
                    ref.read(failNextProvider.notifier).setValue(v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 200),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'AsyncValue 플래그 & when() skip 옵션', code: _code),
      ],
    );
  }
}

/// when() 의 어느 콜백이 호출됐는지 보여주는 색상 배지.
class _Branch extends StatelessWidget {
  const _Branch({required this.color, required this.icon, required this.label});

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text('when 이 $label 호출',
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// skip 옵션 한 줄 토글.
class _OptionSwitch extends StatelessWidget {
  const _OptionSwitch({
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontFamily: 'monospace', fontSize: 13)),
      subtitle: Text(sub, style: Theme.of(context).textTheme.bodySmall),
      value: value,
      onChanged: onChanged,
    );
  }
}

const String _code = r'''
final async = ref.watch(demoDataProvider);

// 동시에 여러 상태일 수 있다 — 로딩 중에도 이전 value 가 남는다.
async.isLoading;     // 새 값 로딩 중(최초·watch·refresh 모두)
async.isReloading;   // 이전 값 보유 + 의존(ref.watch) 변경 재계산 (AsyncLoading)
async.isRefreshing;  // 이전 값 보유 + invalidate/refresh 재계산 (AsyncData/Error)
async.hasValue;      // 값 보유(로딩 중에도 true 가능) / hasError 도 동시 가능
async.value;         // 데이터(nullable). requireValue 는 없으면 예외
async.isFromCache;   // 영속성(persist) 복원값인지 / async.retrying: 재시도 대기

// when 의 skip 옵션으로 "재요청 중 스피너 깜빡임"을 제어한다.
async.when(
  skipLoadingOnReload: false,  // 기본: 의존(watch) 변경 시 loading() 표시
  skipLoadingOnRefresh: true,  // 기본: refresh/invalidate 시 loading() 건너뛰고 이전 data
  skipError: false,            // 기본: 에러면 error() (이전 value 있어도)
  data: (d) => Text('$d'),
  loading: () => const CircularProgressIndicator(),
  error: (e, st) => Text('$e'),
);

// ── 실전 사용 ──
// (1) 당겨서 새로고침/재시도: 기본값 그대로 → 보던 목록 유지(깜빡임 없음)
RefreshIndicator(onRefresh: () => ref.refresh(p.future), child: list);

// (2) 필터/탭/대상(id) 변경(watch 의존): 기본 false 그대로 →
//     옛 데이터는 새 조건과 안 맞으니 스피너로 (잘못된 데이터 잠깐 보이는 것 방지)

// (3) 대시보드/피드: 갱신 실패해도 마지막 정상 데이터를 유지하고 싶다
async.when(
  skipError: true,                  // 에러여도 이전 value 로 data() 호출
  data: (d) => Dashboard(d),        // 화면은 그대로, 에러는 SnackBar 등으로 따로
  loading: () => const Spinner(),
  error: (e, _) => const Spinner(), // 사실상 거의 안 불림(이전 값이 있으면)
);
''';
