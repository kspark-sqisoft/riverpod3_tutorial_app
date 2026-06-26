import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'select_providers.g.dart';

/// 이름과 나이를 가진 간단한 프로필 상태(불변).
class Profile {
  const Profile({required this.name, required this.age});
  final String name;
  final int age;

  Profile copyWith({String? name, int? age}) =>
      Profile(name: name ?? this.name, age: age ?? this.age);

  @override
  String toString() => 'Profile(name: $name, age: $age)';
}

/// 프로필 상태를 관리하는 Notifier. 이름/나이를 따로 바꿀 수 있다.
@riverpod
class ProfileController extends _$ProfileController {
  @override
  Profile build() => const Profile(name: '홍길동', age: 20);

  void rename(String name) => state = state.copyWith(name: name); // 이름만 변경
  void birthday() => state = state.copyWith(age: state.age + 1); // 나이만 변경
}
