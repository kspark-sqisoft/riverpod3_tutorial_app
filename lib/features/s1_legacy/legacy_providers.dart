// Riverpod 3.0 에서 StateProvider / StateNotifierProvider 는
// `package:flutter_riverpod/legacy.dart` 로 이동했다(권장하지 않음).
// 여기서는 "비교 학습"을 위해서만 사용한다 — 신규 코드는 Notifier 를 쓴다.
import 'package:flutter_riverpod/legacy.dart';

/// 레거시 StateProvider 예시(코드생성 아님). 간단한 정수 카운터.
/// 값 변경은 `ref.read(legacyCounterProvider.notifier).state++` 처럼 직접 state 를 만진다.
final legacyCounterProvider = StateProvider<int>((ref) => 0);
