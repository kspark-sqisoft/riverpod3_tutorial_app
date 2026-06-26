import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

/// dummyjson 의 할일(Todo) 모델.
@JsonSerializable()
class Todo {
  const Todo({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  final int id;
  final String todo; // 할일 내용(dummyjson 필드명이 'todo')
  final bool completed;
  final int userId;

  Todo copyWith({bool? completed}) => Todo(
        id: id,
        todo: todo,
        completed: completed ?? this.completed,
        userId: userId,
      );

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
  Map<String, dynamic> toJson() => _$TodoToJson(this);

  // 디버깅/로그용 문자열 표현.
  @override
  String toString() =>
      'Todo(id: $id, todo: $todo, completed: $completed, userId: $userId)';
}
