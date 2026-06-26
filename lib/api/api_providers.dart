import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'dummyjson_client.dart';

part 'api_providers.g.dart';

/// dummyjson 클라이언트를 공급하는 provider.
///
/// 여러 토픽이 공유하는 "인프라"이므로 keepAlive: true 로 항상 살아있게 둔다.
/// 테스트에서는 이 provider 를 override 해 가짜 클라이언트를 주입할 수 있다(토픽 20).
@Riverpod(keepAlive: true)
DummyJsonClient dummyJsonClient(Ref ref) => DummyJsonClient();
