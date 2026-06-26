// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'async_notifier_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// AsyncNotifierProvider: 비동기 초기 로딩 + 상태 변경 메서드를 함께 갖는다.
///
/// build() 가 Future 를 반환하면 상태 타입은 `AsyncValue<List<Todo>>` 가 된다.
/// 메서드에서 state 를 AsyncData/AsyncLoading 으로 바꿔 UI 를 제어한다.

@ProviderFor(TodosController)
final todosControllerProvider = TodosControllerProvider._();

/// AsyncNotifierProvider: 비동기 초기 로딩 + 상태 변경 메서드를 함께 갖는다.
///
/// build() 가 Future 를 반환하면 상태 타입은 `AsyncValue<List<Todo>>` 가 된다.
/// 메서드에서 state 를 AsyncData/AsyncLoading 으로 바꿔 UI 를 제어한다.
final class TodosControllerProvider
    extends $AsyncNotifierProvider<TodosController, List<Todo>> {
  /// AsyncNotifierProvider: 비동기 초기 로딩 + 상태 변경 메서드를 함께 갖는다.
  ///
  /// build() 가 Future 를 반환하면 상태 타입은 `AsyncValue<List<Todo>>` 가 된다.
  /// 메서드에서 state 를 AsyncData/AsyncLoading 으로 바꿔 UI 를 제어한다.
  TodosControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todosControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todosControllerHash();

  @$internal
  @override
  TodosController create() => TodosController();
}

String _$todosControllerHash() => r'f2affc498edfd9d99758812bfadc3f65f7bde33d';

/// AsyncNotifierProvider: 비동기 초기 로딩 + 상태 변경 메서드를 함께 갖는다.
///
/// build() 가 Future 를 반환하면 상태 타입은 `AsyncValue<List<Todo>>` 가 된다.
/// 메서드에서 state 를 AsyncData/AsyncLoading 으로 바꿔 UI 를 제어한다.

abstract class _$TodosController extends $AsyncNotifier<List<Todo>> {
  FutureOr<List<Todo>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Todo>>, List<Todo>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Todo>>, List<Todo>>,
              AsyncValue<List<Todo>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
