// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_for_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// cacheFor: keepAlive 로 즉시 폐기를 막되, "마지막 구독 해제 후 정해진 시간(5초)"만
/// 캐시를 유지하고 그 뒤 폐기하는 패턴.
///
/// 동작:
///  - ref.keepAlive(): 구독 0 이어도 바로 폐기되지 않게 link 를 잡는다.
///  - onCancel(마지막 구독 해제): 5초 타이머 시작 → 만료 시 link.close()로 폐기.
///  - onResume(만료 전 재구독): 타이머 취소 → 캐시 유지(값 그대로).
///  - onDispose: 타이머 정리.
///
/// 결과: 페이지를 떠났다가 5초 안에 돌아오면 "같은 값"(캐시), 5초가 지나면 "새 값"(재생성).

@ProviderFor(cacheForDemo)
final cacheForDemoProvider = CacheForDemoProvider._();

/// cacheFor: keepAlive 로 즉시 폐기를 막되, "마지막 구독 해제 후 정해진 시간(5초)"만
/// 캐시를 유지하고 그 뒤 폐기하는 패턴.
///
/// 동작:
///  - ref.keepAlive(): 구독 0 이어도 바로 폐기되지 않게 link 를 잡는다.
///  - onCancel(마지막 구독 해제): 5초 타이머 시작 → 만료 시 link.close()로 폐기.
///  - onResume(만료 전 재구독): 타이머 취소 → 캐시 유지(값 그대로).
///  - onDispose: 타이머 정리.
///
/// 결과: 페이지를 떠났다가 5초 안에 돌아오면 "같은 값"(캐시), 5초가 지나면 "새 값"(재생성).

final class CacheForDemoProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// cacheFor: keepAlive 로 즉시 폐기를 막되, "마지막 구독 해제 후 정해진 시간(5초)"만
  /// 캐시를 유지하고 그 뒤 폐기하는 패턴.
  ///
  /// 동작:
  ///  - ref.keepAlive(): 구독 0 이어도 바로 폐기되지 않게 link 를 잡는다.
  ///  - onCancel(마지막 구독 해제): 5초 타이머 시작 → 만료 시 link.close()로 폐기.
  ///  - onResume(만료 전 재구독): 타이머 취소 → 캐시 유지(값 그대로).
  ///  - onDispose: 타이머 정리.
  ///
  /// 결과: 페이지를 떠났다가 5초 안에 돌아오면 "같은 값"(캐시), 5초가 지나면 "새 값"(재생성).
  CacheForDemoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cacheForDemoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cacheForDemoHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return cacheForDemo(ref);
  }
}

String _$cacheForDemoHash() => r'd9ee84770f1f312a8b6aa7b579e28dfb82701c0b';

/// 캐시 적용 게시글 상세(family). 위 cacheFor 패턴을 dummyjson /posts/{id} 에 적용.
///
/// 상세 화면을 보면 구독이 생기고, 목록으로 나가면 구독이 사라져 onCancel 이 호출된다.
/// 10초 안에 같은 글을 다시 열면 캐시가 살아 있어(build 재실행 없음 = 네트워크 재요청 없음)
/// 즉시 표시되고, 10초가 지나면 폐기되어 다시 네트워크 요청한다.

@ProviderFor(cachedPost)
final cachedPostProvider = CachedPostFamily._();

/// 캐시 적용 게시글 상세(family). 위 cacheFor 패턴을 dummyjson /posts/{id} 에 적용.
///
/// 상세 화면을 보면 구독이 생기고, 목록으로 나가면 구독이 사라져 onCancel 이 호출된다.
/// 10초 안에 같은 글을 다시 열면 캐시가 살아 있어(build 재실행 없음 = 네트워크 재요청 없음)
/// 즉시 표시되고, 10초가 지나면 폐기되어 다시 네트워크 요청한다.

final class CachedPostProvider
    extends $FunctionalProvider<AsyncValue<Post>, Post, FutureOr<Post>>
    with $FutureModifier<Post>, $FutureProvider<Post> {
  /// 캐시 적용 게시글 상세(family). 위 cacheFor 패턴을 dummyjson /posts/{id} 에 적용.
  ///
  /// 상세 화면을 보면 구독이 생기고, 목록으로 나가면 구독이 사라져 onCancel 이 호출된다.
  /// 10초 안에 같은 글을 다시 열면 캐시가 살아 있어(build 재실행 없음 = 네트워크 재요청 없음)
  /// 즉시 표시되고, 10초가 지나면 폐기되어 다시 네트워크 요청한다.
  CachedPostProvider._({
    required CachedPostFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'cachedPostProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$cachedPostHash();

  @override
  String toString() {
    return r'cachedPostProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Post> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Post> create(Ref ref) {
    final argument = this.argument as int;
    return cachedPost(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CachedPostProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$cachedPostHash() => r'57267e430470e5fea3eb44e6b10d9c5f60408a09';

/// 캐시 적용 게시글 상세(family). 위 cacheFor 패턴을 dummyjson /posts/{id} 에 적용.
///
/// 상세 화면을 보면 구독이 생기고, 목록으로 나가면 구독이 사라져 onCancel 이 호출된다.
/// 10초 안에 같은 글을 다시 열면 캐시가 살아 있어(build 재실행 없음 = 네트워크 재요청 없음)
/// 즉시 표시되고, 10초가 지나면 폐기되어 다시 네트워크 요청한다.

final class CachedPostFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Post>, int> {
  CachedPostFamily._()
    : super(
        retry: null,
        name: r'cachedPostProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 캐시 적용 게시글 상세(family). 위 cacheFor 패턴을 dummyjson /posts/{id} 에 적용.
  ///
  /// 상세 화면을 보면 구독이 생기고, 목록으로 나가면 구독이 사라져 onCancel 이 호출된다.
  /// 10초 안에 같은 글을 다시 열면 캐시가 살아 있어(build 재실행 없음 = 네트워크 재요청 없음)
  /// 즉시 표시되고, 10초가 지나면 폐기되어 다시 네트워크 요청한다.

  CachedPostProvider call(int id) =>
      CachedPostProvider._(argument: id, from: this);

  @override
  String toString() => r'cachedPostProvider';
}
