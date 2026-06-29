import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../api/models/post.dart';
import '../../../shared/app_logger.dart';

part 'cancel_providers.g.dart';

/// 검색어 상태. 입력이 바뀌면 [cancellableSearch] 가 재실행된다.
@riverpod
class CancelQuery extends _$CancelQuery {
  @override
  String build() => '';

  void setQuery(String q) => state = q;
}

/// 취소 가능한 검색 — Riverpod 의 "요청 취소(how_to/cancel)" 패턴을 그대로 보여준다.
///
/// 두 가지 취소를 함께 구현한다:
///  1) didDispose 플래그 — 디바운스 대기 중 재입력/이탈로 이 build 가 폐기되면,
///     대기가 끝난 뒤 검사해 네트워크 요청 자체를 보내지 않고 중단한다(불필요한 요청 절약).
///  2) http.Client.close() — 이미 전송된 HTTP 요청은 onDispose 에서 client 를 닫아 실제로 끊는다.
///
/// 입력이 바뀌면 이전 build 가 폐기되며 onDispose(close + didDispose)가 호출되고,
/// 새 build 가 새 client 로 다시 시작된다 → "진행 중 요청 취소 + 마지막 입력만 통과".
@riverpod
Future<List<Post>> cancellableSearch(Ref ref) async {
  final query = ref.watch(cancelQueryProvider).trim();
  if (query.isEmpty) return const [];

  // 이 build 전용 http 클라이언트 — 폐기되면 close() 로 진행 중 요청을 끊는다.
  final client = http.Client();
  var didDispose = false;
  ref.onDispose(() {
    didDispose = true;
    client.close(); // 전송된 요청이 있으면 즉시 취소(ClientException 유발)
    log.w('🚫 [cancellableSearchProvider] 취소: "$query" (onDispose → close + didDispose)');
  });

  // 디바운스: 잠깐 기다린다. 이 사이 재입력/이탈하면 위 onDispose 가 먼저 호출된다.
  log.t('⏳ [cancellableSearchProvider] 디바운스 대기(450ms): "$query"');
  await Future<void>.delayed(const Duration(milliseconds: 450));

  // 대기 중 폐기됐다면 요청을 보내지 않고 중단(불필요한 네트워크 절약).
  if (didDispose) {
    log.w('🛑 [cancellableSearchProvider] 대기 중 폐기 감지 → 요청 생략');
    throw Exception('취소됨: "$query"');
  }

  log.i('🔎 [cancellableSearchProvider] 검색 실행: "$query"');
  final uri = Uri.parse(
      'https://dummyjson.com/posts/search?q=${Uri.encodeQueryComponent(query)}&limit=10');
  final res = await client.get(uri); // 진행 중 close() 되면 여기서 예외 → 취소
  if (res.statusCode != 200) {
    throw Exception('검색 실패: HTTP ${res.statusCode}');
  }
  final json = jsonDecode(res.body) as Map<String, dynamic>;
  final list = (json['posts'] as List).cast<Map<String, dynamic>>();
  final posts = list.map(Post.fromJson).toList();
  log.i('🔎 [cancellableSearchProvider] 결과 ${posts.length}건: "$query"');
  return posts;
}

// dio 공유 인스턴스. CancelToken 은 요청마다 따로 만들어 연결한다.
final _dio = Dio();

/// dio 버전 취소 — riverpod 공식 pub 예제(examples/pub/lib/detail.dart)와 동일한 패턴.
///
/// http 의 Client.close() 대신, 요청에 CancelToken 을 연결하고 onDispose 에서 cancel() 한다.
/// CancelToken 은 "보내기 전/보낸 뒤"를 한 번에 처리한다:
///  - 대기 중 폐기되어 토큰이 이미 취소됐으면 dio.get 이 곧바로 DioException(type: cancel) 을 던진다(요청 생략).
///  - 전송 중 취소되면 진행 중 요청을 실제로 끊는다.
@riverpod
Future<List<Post>> cancellableSearchDio(Ref ref) async {
  final query = ref.watch(cancelQueryProvider).trim();
  if (query.isEmpty) return const [];

  // 요청 취소용 토큰. provider 가 폐기되면 cancel() 로 진행 중 요청을 끊는다.
  final cancelToken = CancelToken();
  ref.onDispose(() {
    cancelToken.cancel('재입력/이탈로 취소'); // 진행 중이면 즉시 취소
    log.w('🚫 [cancellableSearchDioProvider] 취소: "$query" (onDispose → cancelToken.cancel)');
  });

  log.t('⏳ [cancellableSearchDioProvider] 디바운스 대기(450ms): "$query"');
  await Future<void>.delayed(const Duration(milliseconds: 450));

  log.i('🔎 [cancellableSearchDioProvider] 검색 실행: "$query"');
  // 이미 취소됐다면(대기 중 폐기) dio 가 여기서 DioException(type: cancel) 을 던진다 → 요청 생략.
  final res = await _dio.get<Map<String, dynamic>>(
    'https://dummyjson.com/posts/search',
    queryParameters: {'q': query, 'limit': 10},
    cancelToken: cancelToken, // 이 요청에 취소 토큰 연결
  );
  final list = (res.data!['posts'] as List).cast<Map<String, dynamic>>();
  final posts = list.map(Post.fromJson).toList();
  log.i('🔎 [cancellableSearchDioProvider] 결과 ${posts.length}건: "$query"');
  return posts;
}
