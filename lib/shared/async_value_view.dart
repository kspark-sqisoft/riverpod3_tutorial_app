import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // AsyncValue 사용

/// [AsyncValue] 를 data/loading/error 세 가지 상태로 손쉽게 그려주는 헬퍼.
///
/// FutureProvider/AsyncNotifier/StreamProvider 의 결과를 화면에 그릴 때 반복되는
/// `.when(...)` 분기를 한 곳에 모아 재사용한다.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
  });

  final AsyncValue<T> value; // provider 가 노출하는 비동기 상태
  final Widget Function(T data) data; // 데이터가 있을 때 그릴 위젯
  final VoidCallback? onRetry; // 에러 시 재시도 콜백(선택)

  @override
  Widget build(BuildContext context) {
    // when: 세 상태를 빠짐없이 처리하도록 강제 → 로딩/에러 UI 누락 방지
    return value.when(
      // 데이터 도착
      data: data,
      // 최초 로딩 중
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      // 에러 발생
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
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
