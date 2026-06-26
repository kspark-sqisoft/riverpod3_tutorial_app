import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/post.dart';
import 'models/todo.dart';
import '../shared/app_logger.dart';

/// dummyjson(https://dummyjson.com) 호출을 담당하는 데이터 소스.
///
/// 순수 Dart 클래스(위젯/riverpod 무관)라 테스트에서 가짜 http.Client 로 교체하기 쉽다.
class DummyJsonClient {
  DummyJsonClient([http.Client? client]) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _base = 'https://dummyjson.com';

  // 공통 GET 처리: 상태코드 확인 + JSON 디코드 + 학습 로그.
  Future<Map<String, dynamic>> _getJson(String path) async {
    log.t('🌐 GET $path 요청');
    final res = await _client.get(Uri.parse('$_base$path'));
    if (res.statusCode != 200) {
      throw Exception('요청 실패($path): HTTP ${res.statusCode}');
    }
    log.i('🌐 GET $path 응답 200');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  /// 게시글 목록(limit 개).
  Future<List<Post>> fetchPosts({int limit = 10, int skip = 0}) async {
    // skip: 페이지네이션 오프셋(토픽 35에서 사용). 기본 0 → 기존 호출 호환.
    final json = await _getJson('/posts?limit=$limit&skip=$skip');
    final list = (json['posts'] as List).cast<Map<String, dynamic>>();
    return list.map(Post.fromJson).toList();
  }

  /// dummyjson 전체 게시글 수(페이지네이션 종료 판단용).
  Future<int> fetchPostsTotal() async {
    final json = await _getJson('/posts?limit=1');
    return (json['total'] as num).toInt();
  }

  /// 단일 게시글(id). 토픽 8(family)에서 사용.
  Future<Post> fetchPost(int id) async {
    final json = await _getJson('/posts/$id');
    return Post.fromJson(json);
  }

  /// 게시글 검색. 토픽 22(디바운스)에서 사용.
  Future<List<Post>> searchPosts(String query) async {
    final json = await _getJson('/posts/search?q=${Uri.encodeQueryComponent(query)}');
    final list = (json['posts'] as List).cast<Map<String, dynamic>>();
    return list.map(Post.fromJson).toList();
  }

  /// 할일 목록(limit 개).
  Future<List<Todo>> fetchTodos({int limit = 15}) async {
    final json = await _getJson('/todos?limit=$limit');
    final list = (json['todos'] as List).cast<Map<String, dynamic>>();
    return list.map(Todo.fromJson).toList();
  }

  /// 특정 사용자의 할일. 토픽 8(family)에서 사용.
  Future<List<Todo>> fetchTodosByUser(int userId) async {
    final json = await _getJson('/todos/user/$userId');
    final list = (json['todos'] as List).cast<Map<String, dynamic>>();
    return list.map(Todo.fromJson).toList();
  }

  /// 할일 추가(서버에 실제 저장되지 않고 흉내만 냄 — 데모/낙관적 업데이트용).
  Future<Todo> addTodo({required String todo, int userId = 1}) async {
    log.t('🌐 POST /todos/add: $todo');
    final res = await _client.post(
      Uri.parse('$_base/todos/add'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'todo': todo, 'completed': false, 'userId': userId}),
    );
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('할일 추가 실패: HTTP ${res.statusCode}');
    }
    return Todo.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}
