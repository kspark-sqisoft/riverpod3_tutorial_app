import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/api_providers.dart';
import '../../api/models/post.dart';

part 'family_providers.g.dart';

/// family: 파라미터를 받는 provider.
///
/// 코드생성에서는 family 모디파이어 없이 그냥 "함수 인자"를 추가하면 된다.
/// id 마다 별도의 provider 인스턴스가 만들어지고 각각 따로 캐시된다.
/// (postByIdProvider(1), postByIdProvider(2) 는 서로 다른 상태)
@riverpod
Future<Post> postById(Ref ref, int id) {
  final client = ref.watch(dummyJsonClientProvider); // 클라이언트 주입
  return client.fetchPost(id); // id 별 게시글 로드
}
