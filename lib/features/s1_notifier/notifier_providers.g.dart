// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifier_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// NotifierProvider(코드생성 클래스형): 동기 상태(할일 목록)를 관리한다.
///
/// - build(): 초기 상태를 반환(여기서 호출되는 시점이 Alive 의 시작)
/// - 메서드에서 state 에 "새 리스트"를 대입하면 구독 위젯이 자동 갱신된다.
///   (기존 리스트를 직접 mutate 하면 변경 감지가 안 되므로 항상 새로 만든다.)

@ProviderFor(TodoList)
final todoListProvider = TodoListProvider._();

/// NotifierProvider(코드생성 클래스형): 동기 상태(할일 목록)를 관리한다.
///
/// - build(): 초기 상태를 반환(여기서 호출되는 시점이 Alive 의 시작)
/// - 메서드에서 state 에 "새 리스트"를 대입하면 구독 위젯이 자동 갱신된다.
///   (기존 리스트를 직접 mutate 하면 변경 감지가 안 되므로 항상 새로 만든다.)
final class TodoListProvider
    extends $NotifierProvider<TodoList, List<TodoItem>> {
  /// NotifierProvider(코드생성 클래스형): 동기 상태(할일 목록)를 관리한다.
  ///
  /// - build(): 초기 상태를 반환(여기서 호출되는 시점이 Alive 의 시작)
  /// - 메서드에서 state 에 "새 리스트"를 대입하면 구독 위젯이 자동 갱신된다.
  ///   (기존 리스트를 직접 mutate 하면 변경 감지가 안 되므로 항상 새로 만든다.)
  TodoListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListHash();

  @$internal
  @override
  TodoList create() => TodoList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<TodoItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<TodoItem>>(value),
    );
  }
}

String _$todoListHash() => r'9edda1ede8c6cbb9b3797ce737d1186615569382';

/// NotifierProvider(코드생성 클래스형): 동기 상태(할일 목록)를 관리한다.
///
/// - build(): 초기 상태를 반환(여기서 호출되는 시점이 Alive 의 시작)
/// - 메서드에서 state 에 "새 리스트"를 대입하면 구독 위젯이 자동 갱신된다.
///   (기존 리스트를 직접 mutate 하면 변경 감지가 안 되므로 항상 새로 만든다.)

abstract class _$TodoList extends $Notifier<List<TodoItem>> {
  List<TodoItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<TodoItem>, List<TodoItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<TodoItem>, List<TodoItem>>,
              List<TodoItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
