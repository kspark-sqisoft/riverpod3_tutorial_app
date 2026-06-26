import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// signals 의 [AsyncState] 를 data/loading/error 로 그려주는 헬퍼.
///
/// Riverpod 의 AsyncValueView 와 같은 역할이지만, 대상 타입이 signals 의 AsyncState 다.
/// AsyncState.map 은 refreshing/reloading 빌더를 안 주면 "값이 있으면 data"로 떨어지므로
/// 새로고침 중에도 이전 데이터가 유지된다(깜빡임 없음).
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.state,
    required this.data,
    this.onRetry,
  });

  final AsyncState<T> state; // signals 비동기 상태
  final Widget Function(T data) data; // 데이터일 때 위젯
  final VoidCallback? onRetry; // 에러 시 재시도(선택)

  @override
  Widget build(BuildContext context) {
    return state.map(
      // 데이터 도착(또는 새로고침 중이라도 이전 값 유지)
      data: (value) => data(value),
      // 최초 로딩
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      // 에러
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 8),
            Text('에러: $error', textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('다시 시도'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
