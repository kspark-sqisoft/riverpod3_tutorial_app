import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../shared/app_logger.dart';

part 'retry_providers.g.dart';

// 시도 횟수(모듈 전역). 3의 배수 시도에서만 성공하도록 해 "2번 실패 후 성공"을 반복 재현.
int _attempt = 0;

/// 일시적으로 실패하는 비동기 provider.
///
/// Riverpod 3 은 실패한 provider 를 지수 백오프(200ms→…)로 "자동 재시도"한다.
/// 별도 코드 없이도 시도 #1, #2 가 실패하면 잠시 후 자동으로 #3 을 시도해 성공한다.
/// (로그에서 자동 재시도 흐름을 확인하세요.)
@riverpod
Future<String> autoRetryDemo(Ref ref) async {
  final attempt = ++_attempt;
  log.w('🔁 autoRetryDemo 시도 #$attempt');
  await Future<void>.delayed(const Duration(milliseconds: 300));
  if (attempt % 3 != 0) {
    log.e('❌ 시도 #$attempt 실패 → 자동 재시도 예정');
    throw Exception('일시적 오류 (시도 #$attempt)');
  }
  log.i('✅ 시도 #$attempt 성공');
  return '성공! (시도 #$attempt 만에)';
}
