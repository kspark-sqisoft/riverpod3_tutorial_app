import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../shared/app_logger.dart';

part 'invalidate_refresh_providers.g.dart';

int _builds = 0; // 이 provider 가 몇 번 build 됐는지(모듈 전역)

/// 호출(build)될 때마다 카운트를 올리는 provider.
/// invalidate/refresh 로 "재계산이 일어나는지"를 값 증가로 관찰한다.
@riverpod
int rebuildCounter(Ref ref) {
  _builds++;
  log.t('🟢 rebuildCounter build #$_builds');
  return _builds;
}
