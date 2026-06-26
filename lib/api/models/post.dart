import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

/// dummyjson 의 게시글(Post) 모델. json_serializable 로 (역)직렬화 코드 생성.
@JsonSerializable()
class Post {
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
    this.tags = const [],
  });

  final int id;
  final String title;
  final String body;
  final int userId;
  final List<String> tags;

  // fromJson/toJson 은 생성된 _$...에 위임한다.
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);

  // 디버깅/로그용 문자열 표현. body 는 길 수 있어 제외하고 요약만 표시.
  @override
  String toString() =>
      'Post(id: $id, title: $title, userId: $userId, tags: $tags)';
}
