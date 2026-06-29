import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/async_value_view.dart';
import '../../../shared/code_snippet.dart';
import '../../../shared/concept_page.dart';
import '../clean_arch_providers.dart';
import '../domain/todo_entity.dart';

/// 토픽 14: DI 컨테이너 & 클린 아키텍처 — 로컬 인메모리 Todo CRUD.
class CleanArchPage extends ConsumerStatefulWidget {
  const CleanArchPage({super.key});

  @override
  ConsumerState<CleanArchPage> createState() => _CleanArchPageState();
}

class _CleanArchPageState extends ConsumerState<CleanArchPage> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final text = _input.text.trim();
    if (text.isEmpty) return; // 빈 입력은 무시(유스케이스도 한 번 더 검증)
    _input.clear();
    await ref.read(todoListControllerProvider.notifier).add(text);
  }

  @override
  Widget build(BuildContext context) {
    final todosAsync = ref.watch(todoListControllerProvider);

    return ConceptPage(
      title: '14. DI 컨테이너 & 클린 아키텍처',
      explanation:
          '클린 아키텍처의 핵심은 "의존성 방향"입니다. 바깥(프레젠테이션/데이터)이 안(도메인)을 향하게 하고, '
          '도메인은 Flutter·HTTP·DB 를 전혀 모르게 둡니다. 그러면 UI 프레임워크나 데이터 출처(인메모리→DB→서버)가 '
          '바뀌어도 도메인과 화면 로직은 그대로 재사용됩니다. 레이어는 셋입니다. '
          '① domain(가장 안쪽): 순수 엔티티(TodoEntity), 추상 저장소 인터페이스(LocalTodoRepository), '
          '유스케이스(GetTodos/AddTodo/…) — "무엇을 할 수 있는가"와 비즈니스 규칙(예: 공백 제목 거부)만 담습니다. '
          '② data: 인터페이스의 실제 구현(InMemoryTodoRepository) — 저장/조회의 "어떻게"를 담당하고, 필요하면 '
          'DTO↔엔티티 매핑을 합니다. ③ presentation: 컨트롤러(TodoListController)가 유스케이스를 호출해 화면 상태를 '
          '만들고, 위젯은 컨트롤러만 watch 합니다. 의존성 역전(DIP)의 비밀은 "추상에만 의존"하는 것 — 도메인이 추상 '
          'LocalTodoRepository 를 정의하고, data 가 그것을 구현하며, 둘을 잇는 배선은 Riverpod 의 DI 한 곳'
          '(localTodoRepositoryProvider)에서만 일어납니다. 그래서 테스트에선 그 provider 하나만 override 하면 '
          '저장소를 통째로 가짜로 바꿀 수 있습니다. 아래 데모는 실제로 동작하는 로컬 CRUD 이며, 그 아래에 각 레이어와 '
          '테스트 코드를 모두 담았습니다. Riverpod 의 ProviderScope 가 곧 DI 컨테이너입니다 — provider 가 "등록", '
          'ref.watch/read 가 "주입", override 가 "재바인딩".',
      points: const [
        '의존성 규칙: presentation·data → domain (안쪽은 바깥을 모름)',
        'domain: 엔티티 + 추상 저장소 + 유스케이스(비즈니스 규칙·검증)',
        'data: 추상 저장소의 구현(인메모리/DB/HTTP) — 교체 가능',
        'presentation: 컨트롤러(AsyncNotifier)가 유스케이스 호출 → UI 는 컨트롤러만 watch',
        'DIP: 도메인이 인터페이스를 정의, data 가 구현 — 배선은 DI 한 곳',
        'Riverpod = DI 컨테이너: provider 등록 · ref 주입 · override 재바인딩',
        '테스트: localTodoRepositoryProvider 만 override → 저장소 통째 교체',
      ],
      demo: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 의존성 방향 도식
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'presentation  →  domain  ←  data\n'
                'TodoListController        InMemoryTodoRepository\n'
                '   │ uses                        │ implements\n'
                '   ▼                             ▼\n'
                'GetTodos/AddTodo/…   →   LocalTodoRepository «추상»\n'
                '          (배선: localTodoRepositoryProvider 한 곳)',
                style: TextStyle(fontFamily: 'monospace', height: 1.5, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // 라이브 로컬 CRUD
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _input,
                          decoration: const InputDecoration(
                            labelText: '할일 입력 후 추가',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onSubmitted: (_) => _add(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton.icon(
                        onPressed: _add,
                        icon: const Icon(Icons.add),
                        label: const Text('추가'),
                      ),
                    ],
                  ),
                  const Divider(),
                  AsyncValueView<List<TodoEntity>>(
                    value: todosAsync,
                    onRetry: () => ref.invalidate(todoListControllerProvider),
                    data: (todos) => todos.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text('할일이 없습니다. 위에서 추가해 보세요.'))
                        : Column(
                            children: [
                              for (final t in todos)
                                ListTile(
                                  dense: true,
                                  leading: Checkbox(
                                    value: t.done,
                                    onChanged: (_) => ref
                                        .read(todoListControllerProvider.notifier)
                                        .toggle(t.id),
                                  ),
                                  title: Text(
                                    t.title,
                                    style: t.done
                                        ? const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough)
                                        : null,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => ref
                                        .read(todoListControllerProvider.notifier)
                                        .remove(t.id),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      snippets: const [
        CodeSnippet(
            title: 'domain/todo_entity.dart (엔티티 — 순수 모델)',
            code: _codeEntity),
        CodeSnippet(
            title: 'domain/local_todo_repository.dart (추상 저장소)',
            code: _codeRepo),
        CodeSnippet(
            title: 'domain/todo_usecases.dart (유스케이스 — 비즈니스 규칙)',
            code: _codeUsecases),
        CodeSnippet(
            title: 'data/in_memory_todo_repository.dart (구현)',
            code: _codeImpl),
        CodeSnippet(
            title: 'clean_arch_providers.dart (DI 배선 + 컨트롤러)',
            code: _codeDi),
        CodeSnippet(
            title: 'presentation — UI 는 컨트롤러만 watch', code: _codeUi),
        CodeSnippet(
            title: 'test/clean_arch_local_test.dart (유닛 + 컨트롤러 테스트)',
            code: _codeTest),
      ],
    );
  }
}

const String _codeEntity = r'''
/// 도메인 엔티티: Flutter/HTTP/JSON 을 전혀 모르는 순수 모델.
class TodoEntity {
  const TodoEntity({required this.id, required this.title, required this.done});
  final int id;
  final String title;
  final bool done;

  TodoEntity copyWith({String? title, bool? done}) => TodoEntity(
        id: id, title: title ?? this.title, done: done ?? this.done);
}
''';

const String _codeRepo = r'''
/// 추상 저장소(도메인 인터페이스) — CRUD 계약만. 구현은 data 레이어.
abstract interface class LocalTodoRepository {
  Future<List<TodoEntity>> getAll();
  Future<TodoEntity> add(String title);
  Future<void> toggle(int id);
  Future<void> remove(int id);
}
''';

const String _codeUsecases = r'''
/// 유스케이스: "하나의 동작" + 비즈니스 규칙을 캡슐화. 컨트롤러는 이것만 호출한다.
class GetTodos {
  const GetTodos(this._repo);
  final LocalTodoRepository _repo;
  Future<List<TodoEntity>> call() => _repo.getAll();
}

class AddTodo {
  const AddTodo(this._repo);
  final LocalTodoRepository _repo;
  Future<TodoEntity> call(String title) {
    final t = title.trim();
    if (t.isEmpty) throw ArgumentError('할일 제목은 비어 있을 수 없습니다'); // 도메인 규칙
    return _repo.add(t);
  }
}

class ToggleTodo {
  const ToggleTodo(this._repo);
  final LocalTodoRepository _repo;
  Future<void> call(int id) => _repo.toggle(id);
}

class DeleteTodo {
  const DeleteTodo(this._repo);
  final LocalTodoRepository _repo;
  Future<void> call(int id) => _repo.remove(id);
}
''';

const String _codeImpl = r'''
/// 데이터 레이어 구현: 앱 메모리에 저장. sqflite/HTTP 로 바꿔도 인터페이스가 같아
/// 도메인/화면은 그대로(DI 한 곳만 교체).
class InMemoryTodoRepository implements LocalTodoRepository {
  final List<TodoEntity> _todos = [ /* 시드 2개 */ ];
  int _nextId = 3;

  @override
  Future<List<TodoEntity>> getAll() async => List.unmodifiable(_todos);

  @override
  Future<TodoEntity> add(String title) async {
    final todo = TodoEntity(id: _nextId++, title: title, done: false);
    _todos.add(todo);
    return todo;
  }

  @override
  Future<void> toggle(int id) async {
    final i = _todos.indexWhere((t) => t.id == id);
    if (i != -1) _todos[i] = _todos[i].copyWith(done: !_todos[i].done);
  }

  @override
  Future<void> remove(int id) async => _todos.removeWhere((t) => t.id == id);
}
''';

const String _codeDi = r'''
// DI ①: 추상 ↔ 구현 연결(여기만 구현을 안다). keepAlive 로 메모리 유지.
@Riverpod(keepAlive: true)
LocalTodoRepository localTodoRepository(Ref ref) => InMemoryTodoRepository();

// DI ②: 유스케이스 — 저장소(추상)를 주입해 생성
@riverpod
GetTodos getTodos(Ref ref) => GetTodos(ref.watch(localTodoRepositoryProvider));
@riverpod
AddTodo addTodo(Ref ref) => AddTodo(ref.watch(localTodoRepositoryProvider));
// (toggleTodo / deleteTodo 도 동일)

// DI ③: 컨트롤러 — 유스케이스를 호출하고 invalidateSelf 로 목록을 다시 읽는다
@riverpod
class TodoListController extends _$TodoListController {
  @override
  Future<List<TodoEntity>> build() => ref.watch(getTodosProvider).call();

  Future<void> add(String title) async {
    await ref.read(addTodoProvider).call(title);
    ref.invalidateSelf();
    await future;
  }
  // toggle(id) / remove(id) 도 동일 패턴
}
''';

const String _codeUi = r'''
class _TodoView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UI 는 컨트롤러만 안다 — 저장소/유스케이스/구현은 전혀 모른다.
    final async = ref.watch(todoListControllerProvider);
    final ctrl = ref.read(todoListControllerProvider.notifier);
    return async.when(
      data: (todos) => ListView(children: [
        for (final t in todos)
          CheckboxListTile(
            value: t.done,
            onChanged: (_) => ctrl.toggle(t.id),
            title: Text(t.title),
          ),
      ]),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('$e'),
    );
  }
}
''';

const String _codeTest = r'''
// 가짜 저장소(도메인 인터페이스만 구현) — 네트워크/실DB 없이 검증
class _FakeRepo implements LocalTodoRepository { /* 인메모리와 동일 로직 */ }

void main() {
  // 1) 유스케이스 단위 테스트 — 도메인 규칙(공백 거부)
  test('AddTodo: 공백 제목은 ArgumentError', () {
    final add = AddTodo(_FakeRepo());
    expect(() => add('   '), throwsArgumentError);
  });

  // 2) 컨트롤러 테스트 — 저장소 provider 만 override 해 격리
  test('TodoListController: add 하면 목록이 늘어난다', () async {
    final container = ProviderContainer.test(overrides: [
      localTodoRepositoryProvider.overrideWithValue(_FakeRepo()),
    ]);
    final before = await container.read(todoListControllerProvider.future);
    await container.read(todoListControllerProvider.notifier).add('새 할일');
    final after = await container.read(todoListControllerProvider.future);
    expect(after.length, before.length + 1);
  });
}
''';
