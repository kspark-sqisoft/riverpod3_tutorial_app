import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/api_providers.dart';
import '../../../api/models/post.dart';
import '../../../shared/app_logger.dart';

part 'cache_for_providers.g.dart';

String _now() {
  final t = DateTime.now();
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
}

/// cacheFor: keepAlive 로 즉시 폐기를 막되, "마지막 구독 해제 후 정해진 시간(5초)"만
/// 캐시를 유지하고 그 뒤 폐기하는 패턴.
///
/// 동작:
///  - ref.keepAlive(): 구독 0 이어도 바로 폐기되지 않게 link 를 잡는다.
///  - onCancel(마지막 구독 해제): 5초 타이머 시작 → 만료 시 link.close()로 폐기.
///  - onResume(만료 전 재구독): 타이머 취소 → 캐시 유지(값 그대로).
///  - onDispose: 타이머 정리.
///
/// 결과: 페이지를 떠났다가 5초 안에 돌아오면 "같은 값"(캐시), 5초가 지나면 "새 값"(재생성).
@riverpod
Future<String> cacheForDemo(Ref ref) async {
  final link = ref.keepAlive(); // 즉시 폐기 방지
  Timer? timer;

  // 마지막 구독이 사라지면 5초 후 캐시 폐기 예약
  ref.onCancel(() {
    log.w('⏸️ [cacheFor] 구독 0 → 5초 후 캐시 폐기 예약');
    timer = Timer(const Duration(seconds: 5), () {
      log.i('⌛ [cacheFor] 5초 경과 → 캐시 폐기(link.close)');
      link.close(); // 이제 autoDispose 처럼 폐기됨
    });
  });

  // 만료 전에 다시 구독되면 타이머 취소 → 캐시 유지
  ref.onResume(() {
    log.d('▶️ [cacheFor] 만료 전 재구독 → 캐시 유지(타이머 취소)');
    timer?.cancel();
  });

  // 폐기 시 타이머 정리(누수 방지)
  ref.onDispose(() {
    timer?.cancel();
    log.i('⚪ [cacheFor] dispose');
  });

  log.t('🟢 [cacheFor] build — 데이터 새로 생성');
  await Future<void>.delayed(const Duration(milliseconds: 500)); // 생성 비용 흉내
  return '생성 시각 ${_now()}';
}

/// 캐시 적용 게시글 상세(family). 위 cacheFor 패턴을 dummyjson /posts/{id} 에 적용.
///
/// 상세 화면을 보면 구독이 생기고, 목록으로 나가면 구독이 사라져 onCancel 이 호출된다.
/// 10초 안에 같은 글을 다시 열면 캐시가 살아 있어(build 재실행 없음 = 네트워크 재요청 없음)
/// 즉시 표시되고, 10초가 지나면 폐기되어 다시 네트워크 요청한다.
@riverpod
Future<Post> cachedPost(Ref ref, int id) async {
  final link = ref.keepAlive(); // 즉시 폐기 방지
  Timer? timer;

  ref.onCancel(() {
    log.w('⏸️ [cachedPost($id)] 상세 닫힘(구독 0) → 10초 후 캐시 폐기 예약');
    timer = Timer(const Duration(seconds: 10), () {
      log.i('⌛ [cachedPost($id)] 10초 경과 → 캐시 폐기');
      link.close();
    });
  });
  ref.onResume(() {
    log.d('▶️ [cachedPost($id)] 10초 안에 재진입 → 캐시 사용(타이머 취소, 재요청 없음)');
    timer?.cancel();
  });
  ref.onDispose(() {
    timer?.cancel();
    log.i('⚪ [cachedPost($id)] dispose');
  });

  // 이 로그/네트워크 호출이 "다시 찍히면" = 캐시 미스(재요청), 안 찍히면 = 캐시 사용
  log.t('🌐 [cachedPost($id)] build — 네트워크 요청(/posts/$id)');
  final client = ref.read(dummyJsonClientProvider);
  return client.fetchPost(id);
}
