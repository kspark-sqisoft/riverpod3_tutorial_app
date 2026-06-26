import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/code_snippet.dart';
import '../../shared/concept_page.dart';
import '../../shared/lifecycle_log_view.dart';
import 'keepalive_providers.dart';

/// 토픽 9: autoDispose & keepAlive — provider 의 폐기/유지.
class KeepAlivePage extends ConsumerStatefulWidget {
  const KeepAlivePage({super.key});

  @override
  ConsumerState<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends ConsumerState<KeepAlivePage> {
  bool _show = true; // 구독 위젯을 보였다/숨겼다 → 구독 생성/해제

  @override
  Widget build(BuildContext context) {
    return ConceptPage(
      title: '9. autoDispose & keepAlive',
      explanation:
          '코드생성 provider 는 기본이 autoDispose 입니다. 구독자가 모두 사라지면 폐기되고, '
          '다시 구독하면 build 가 재실행됩니다. @Riverpod(keepAlive: true) 를 붙이면 '
          '구독자가 없어도 상태가 유지됩니다. 아래 스위치로 구독 위젯을 껐다 켜보며 '
          '두 provider 의 "생성 시각"이 어떻게 달라지는지(로그와 함께) 확인하세요.',
      points: const [
        'autoDispose(기본): 구독자 0 → 폐기, 재구독 시 새로 build',
        '@Riverpod(keepAlive: true): 구독자 0 이어도 상태 유지',
        '스위치 OFF → autoDisposeStamp 만 dispose 로그가 찍힌다',
        '스위치 다시 ON → autoDispose 는 시각이 갱신, keepAlive 는 그대로',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('구독 위젯 표시(ON) / 숨김(OFF)'),
                  value: _show,
                  onChanged: (v) => setState(() => _show = v),
                ),
                if (_show) const Padding(
                  padding: EdgeInsets.all(16),
                  child: _StampWatchers(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const LifecycleLogView(height: 180),
        ],
      ),
      snippets: const [
        CodeSnippet(title: 'keepalive_providers.dart', code: _code),
      ],
    );
  }
}

/// 두 provider 의 값을 함께 구독해 보여주는 위젯.
/// 이 위젯이 사라지면(스위치 OFF) 구독이 해제된다.
class _StampWatchers extends ConsumerWidget {
  const _StampWatchers();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auto = ref.watch(autoDisposeStampProvider);
    final kept = ref.watch(keepAliveStampProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('autoDispose 생성 시각: $auto'),
        const SizedBox(height: 4),
        Text('keepAlive 생성 시각: $kept'),
      ],
    );
  }
}

const String _code = r'''
@riverpod                       // 기본 autoDispose
String autoDisposeStamp(Ref ref) {
  ref.onDispose(() => /* 폐기 로그 */);
  return nowHHmmss();           // 재구독 시 새로 생성 → 시각 갱신
}

@Riverpod(keepAlive: true)      // 폐기되지 않음
String keepAliveStamp(Ref ref) {
  ref.onDispose(() => /* 거의 호출 안 됨 */);
  return nowHHmmss();           // 한 번 만들면 유지
}
''';
