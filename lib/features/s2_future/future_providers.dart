import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/api_providers.dart';
import '../../api/models/post.dart';

part 'future_providers.g.dart';

/// FutureProvider(코드생성 함수형): 비동기로 게시글 목록을 가져온다.
///
/// 반환 타입이 `Future<T>` 이면 Riverpod 이 자동으로 `AsyncValue<T>` 로 감싸
/// loading/error/data 상태를 관리해 준다. 우리는 Future 만 돌려주면 된다.
@riverpod
Future<List<Post>> postsList(Ref ref) {
  final client = ref.watch(dummyJsonClientProvider); // 클라이언트 주입
  return client.fetchPosts(limit: 10); // 이 Future 가 AsyncValue 로 변환됨
}
