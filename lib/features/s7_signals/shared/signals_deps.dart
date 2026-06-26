import '../../../api/dummyjson_client.dart';

/// signals 에는 Riverpod 같은 DI 컨테이너가 없다.
/// 그래서 공유 의존성(여기선 API 클라이언트)을 그냥 전역 변수로 직접 만들어 쓴다.
/// (이 자체가 "signals엔 DI가 없다"는 비교 포인트 — 토픽 33에서 정리)
final DummyJsonClient signalsClient = DummyJsonClient();
