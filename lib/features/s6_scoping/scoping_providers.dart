import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scoping_providers.g.dart';

/// 스코프 전용 provider.
///
/// 기본 구현은 예외를 던지고, 실제 값은 ProviderScope(overrides:) 로 "서브트리마다" 주입한다.
/// 리스트 아이템처럼 같은 위젯을 여러 번 쓰되 각자 다른 값을 흘려보내고 싶을 때 유용하다.
/// (코드생성에서 스코프 의존성을 명시하려면 @Riverpod(dependencies: [...]) 를 사용한다.)
@riverpod
String currentItem(Ref ref) => throw UnimplementedError(
      'currentItemProvider 는 ProviderScope(overrides:) 로 주입해야 합니다',
    );
