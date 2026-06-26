// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clean_arch_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI 배선 ①: 추상 [TodoRepository] 를 실제 구현으로 연결한다.
///
/// "여기"가 유일하게 구현(TodoRepositoryImpl)을 아는 지점이다.
/// 테스트/데모에서는 이 provider 만 override 하면 구현을 통째로 바꿀 수 있다(토픽 15).

@ProviderFor(todoRepository)
final todoRepositoryProvider = TodoRepositoryProvider._();

/// DI 배선 ①: 추상 [TodoRepository] 를 실제 구현으로 연결한다.
///
/// "여기"가 유일하게 구현(TodoRepositoryImpl)을 아는 지점이다.
/// 테스트/데모에서는 이 provider 만 override 하면 구현을 통째로 바꿀 수 있다(토픽 15).

final class TodoRepositoryProvider
    extends $FunctionalProvider<TodoRepository, TodoRepository, TodoRepository>
    with $Provider<TodoRepository> {
  /// DI 배선 ①: 추상 [TodoRepository] 를 실제 구현으로 연결한다.
  ///
  /// "여기"가 유일하게 구현(TodoRepositoryImpl)을 아는 지점이다.
  /// 테스트/데모에서는 이 provider 만 override 하면 구현을 통째로 바꿀 수 있다(토픽 15).
  TodoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoRepositoryHash();

  @$internal
  @override
  $ProviderElement<TodoRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoRepository create(Ref ref) {
    return todoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoRepository>(value),
    );
  }
}

String _$todoRepositoryHash() => r'b078f1f876ba52036845f19bd95fd55fa93cb05f';

/// DI 배선 ②: 컨트롤러(프레젠테이션)는 추상 타입에만 의존한다.
///
/// repo 의 실제 구현이 무엇인지 모른 채 getTodos() 만 호출 → 결합도가 낮다.

@ProviderFor(cleanTodos)
final cleanTodosProvider = CleanTodosProvider._();

/// DI 배선 ②: 컨트롤러(프레젠테이션)는 추상 타입에만 의존한다.
///
/// repo 의 실제 구현이 무엇인지 모른 채 getTodos() 만 호출 → 결합도가 낮다.

final class CleanTodosProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TodoEntity>>,
          List<TodoEntity>,
          FutureOr<List<TodoEntity>>
        >
    with $FutureModifier<List<TodoEntity>>, $FutureProvider<List<TodoEntity>> {
  /// DI 배선 ②: 컨트롤러(프레젠테이션)는 추상 타입에만 의존한다.
  ///
  /// repo 의 실제 구현이 무엇인지 모른 채 getTodos() 만 호출 → 결합도가 낮다.
  CleanTodosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cleanTodosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cleanTodosHash();

  @$internal
  @override
  $FutureProviderElement<List<TodoEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TodoEntity>> create(Ref ref) {
    return cleanTodos(ref);
  }
}

String _$cleanTodosHash() => r'e9253c7ff9afc1e67e6323aa24a8ea07b075ca9a';
