// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clean_arch_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// DI ①: 추상 [LocalTodoRepository] 를 인메모리 구현으로 연결(여기만 구현을 안다).
/// keepAlive: 화면을 떠나도 추가한 할일이 사라지지 않게 메모리를 유지.
/// 테스트에서는 이 provider 만 override 하면 저장소를 통째로 바꿀 수 있다.

@ProviderFor(localTodoRepository)
final localTodoRepositoryProvider = LocalTodoRepositoryProvider._();

/// DI ①: 추상 [LocalTodoRepository] 를 인메모리 구현으로 연결(여기만 구현을 안다).
/// keepAlive: 화면을 떠나도 추가한 할일이 사라지지 않게 메모리를 유지.
/// 테스트에서는 이 provider 만 override 하면 저장소를 통째로 바꿀 수 있다.

final class LocalTodoRepositoryProvider
    extends
        $FunctionalProvider<
          LocalTodoRepository,
          LocalTodoRepository,
          LocalTodoRepository
        >
    with $Provider<LocalTodoRepository> {
  /// DI ①: 추상 [LocalTodoRepository] 를 인메모리 구현으로 연결(여기만 구현을 안다).
  /// keepAlive: 화면을 떠나도 추가한 할일이 사라지지 않게 메모리를 유지.
  /// 테스트에서는 이 provider 만 override 하면 저장소를 통째로 바꿀 수 있다.
  LocalTodoRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localTodoRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localTodoRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocalTodoRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalTodoRepository create(Ref ref) {
    return localTodoRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalTodoRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalTodoRepository>(value),
    );
  }
}

String _$localTodoRepositoryHash() =>
    r'6cdec661677181513898d82b7d306bed09447b4f';

/// DI ②: 유스케이스 — 저장소(추상)를 주입해 만든다. 컨트롤러는 이 유스케이스에만 의존.

@ProviderFor(getTodos)
final getTodosProvider = GetTodosProvider._();

/// DI ②: 유스케이스 — 저장소(추상)를 주입해 만든다. 컨트롤러는 이 유스케이스에만 의존.

final class GetTodosProvider
    extends $FunctionalProvider<GetTodos, GetTodos, GetTodos>
    with $Provider<GetTodos> {
  /// DI ②: 유스케이스 — 저장소(추상)를 주입해 만든다. 컨트롤러는 이 유스케이스에만 의존.
  GetTodosProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getTodosProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getTodosHash();

  @$internal
  @override
  $ProviderElement<GetTodos> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetTodos create(Ref ref) {
    return getTodos(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetTodos value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetTodos>(value),
    );
  }
}

String _$getTodosHash() => r'2a795b8d9e5318e4f8f400e5136dd32c9920b0fe';

@ProviderFor(addTodo)
final addTodoProvider = AddTodoProvider._();

final class AddTodoProvider
    extends $FunctionalProvider<AddTodo, AddTodo, AddTodo>
    with $Provider<AddTodo> {
  AddTodoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addTodoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addTodoHash();

  @$internal
  @override
  $ProviderElement<AddTodo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AddTodo create(Ref ref) {
    return addTodo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddTodo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddTodo>(value),
    );
  }
}

String _$addTodoHash() => r'd1231792204c4ce54f6e60b9b107d15bb51571d1';

@ProviderFor(toggleTodo)
final toggleTodoProvider = ToggleTodoProvider._();

final class ToggleTodoProvider
    extends $FunctionalProvider<ToggleTodo, ToggleTodo, ToggleTodo>
    with $Provider<ToggleTodo> {
  ToggleTodoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'toggleTodoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$toggleTodoHash();

  @$internal
  @override
  $ProviderElement<ToggleTodo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ToggleTodo create(Ref ref) {
    return toggleTodo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ToggleTodo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ToggleTodo>(value),
    );
  }
}

String _$toggleTodoHash() => r'c0be8a71d2dddc264bdff6c8afb98028a5c9c6f9';

@ProviderFor(deleteTodo)
final deleteTodoProvider = DeleteTodoProvider._();

final class DeleteTodoProvider
    extends $FunctionalProvider<DeleteTodo, DeleteTodo, DeleteTodo>
    with $Provider<DeleteTodo> {
  DeleteTodoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteTodoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteTodoHash();

  @$internal
  @override
  $ProviderElement<DeleteTodo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeleteTodo create(Ref ref) {
    return deleteTodo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeleteTodo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeleteTodo>(value),
    );
  }
}

String _$deleteTodoHash() => r'9247b0520c2b66aad42dcf7472b55776bdd190df';

/// DI ③(프레젠테이션): 화면 상태를 들고 유스케이스를 호출하는 컨트롤러.
///
/// build() 는 GetTodos 로 목록을 읽어 AsyncValue<List<TodoEntity>> 로 노출하고,
/// add/toggle/remove 는 해당 유스케이스를 호출한 뒤 invalidateSelf 로 목록을 다시 읽는다.
/// (화면은 이 컨트롤러만 watch 하면 되고, 저장소/구현은 전혀 모른다.)

@ProviderFor(TodoListController)
final todoListControllerProvider = TodoListControllerProvider._();

/// DI ③(프레젠테이션): 화면 상태를 들고 유스케이스를 호출하는 컨트롤러.
///
/// build() 는 GetTodos 로 목록을 읽어 AsyncValue<List<TodoEntity>> 로 노출하고,
/// add/toggle/remove 는 해당 유스케이스를 호출한 뒤 invalidateSelf 로 목록을 다시 읽는다.
/// (화면은 이 컨트롤러만 watch 하면 되고, 저장소/구현은 전혀 모른다.)
final class TodoListControllerProvider
    extends $AsyncNotifierProvider<TodoListController, List<TodoEntity>> {
  /// DI ③(프레젠테이션): 화면 상태를 들고 유스케이스를 호출하는 컨트롤러.
  ///
  /// build() 는 GetTodos 로 목록을 읽어 AsyncValue<List<TodoEntity>> 로 노출하고,
  /// add/toggle/remove 는 해당 유스케이스를 호출한 뒤 invalidateSelf 로 목록을 다시 읽는다.
  /// (화면은 이 컨트롤러만 watch 하면 되고, 저장소/구현은 전혀 모른다.)
  TodoListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListControllerHash();

  @$internal
  @override
  TodoListController create() => TodoListController();
}

String _$todoListControllerHash() =>
    r'b30d0094fdb830e0571f828529e0a03f5e1fc381';

/// DI ③(프레젠테이션): 화면 상태를 들고 유스케이스를 호출하는 컨트롤러.
///
/// build() 는 GetTodos 로 목록을 읽어 AsyncValue<List<TodoEntity>> 로 노출하고,
/// add/toggle/remove 는 해당 유스케이스를 호출한 뒤 invalidateSelf 로 목록을 다시 읽는다.
/// (화면은 이 컨트롤러만 watch 하면 되고, 저장소/구현은 전혀 모른다.)

abstract class _$TodoListController extends $AsyncNotifier<List<TodoEntity>> {
  FutureOr<List<TodoEntity>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<TodoEntity>>, List<TodoEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TodoEntity>>, List<TodoEntity>>,
              AsyncValue<List<TodoEntity>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

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
