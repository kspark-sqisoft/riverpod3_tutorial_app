// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 검색어 상태. 입력이 바뀌면 [cancellableSearch] 가 재실행된다.

@ProviderFor(CancelQuery)
final cancelQueryProvider = CancelQueryProvider._();

/// 검색어 상태. 입력이 바뀌면 [cancellableSearch] 가 재실행된다.
final class CancelQueryProvider extends $NotifierProvider<CancelQuery, String> {
  /// 검색어 상태. 입력이 바뀌면 [cancellableSearch] 가 재실행된다.
  CancelQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelQueryHash();

  @$internal
  @override
  CancelQuery create() => CancelQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$cancelQueryHash() => r'4d5d7611136666402f95d9fa8b9e2943ffcc188c';

/// 검색어 상태. 입력이 바뀌면 [cancellableSearch] 가 재실행된다.

abstract class _$CancelQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 취소 가능한 검색 — Riverpod 의 "요청 취소(how_to/cancel)" 패턴을 그대로 보여준다.
///
/// 두 가지 취소를 함께 구현한다:
///  1) didDispose 플래그 — 디바운스 대기 중 재입력/이탈로 이 build 가 폐기되면,
///     대기가 끝난 뒤 검사해 네트워크 요청 자체를 보내지 않고 중단한다(불필요한 요청 절약).
///  2) http.Client.close() — 이미 전송된 HTTP 요청은 onDispose 에서 client 를 닫아 실제로 끊는다.
///
/// 입력이 바뀌면 이전 build 가 폐기되며 onDispose(close + didDispose)가 호출되고,
/// 새 build 가 새 client 로 다시 시작된다 → "진행 중 요청 취소 + 마지막 입력만 통과".

@ProviderFor(cancellableSearch)
final cancellableSearchProvider = CancellableSearchProvider._();

/// 취소 가능한 검색 — Riverpod 의 "요청 취소(how_to/cancel)" 패턴을 그대로 보여준다.
///
/// 두 가지 취소를 함께 구현한다:
///  1) didDispose 플래그 — 디바운스 대기 중 재입력/이탈로 이 build 가 폐기되면,
///     대기가 끝난 뒤 검사해 네트워크 요청 자체를 보내지 않고 중단한다(불필요한 요청 절약).
///  2) http.Client.close() — 이미 전송된 HTTP 요청은 onDispose 에서 client 를 닫아 실제로 끊는다.
///
/// 입력이 바뀌면 이전 build 가 폐기되며 onDispose(close + didDispose)가 호출되고,
/// 새 build 가 새 client 로 다시 시작된다 → "진행 중 요청 취소 + 마지막 입력만 통과".

final class CancellableSearchProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>
        >
    with $FutureModifier<List<Post>>, $FutureProvider<List<Post>> {
  /// 취소 가능한 검색 — Riverpod 의 "요청 취소(how_to/cancel)" 패턴을 그대로 보여준다.
  ///
  /// 두 가지 취소를 함께 구현한다:
  ///  1) didDispose 플래그 — 디바운스 대기 중 재입력/이탈로 이 build 가 폐기되면,
  ///     대기가 끝난 뒤 검사해 네트워크 요청 자체를 보내지 않고 중단한다(불필요한 요청 절약).
  ///  2) http.Client.close() — 이미 전송된 HTTP 요청은 onDispose 에서 client 를 닫아 실제로 끊는다.
  ///
  /// 입력이 바뀌면 이전 build 가 폐기되며 onDispose(close + didDispose)가 호출되고,
  /// 새 build 가 새 client 로 다시 시작된다 → "진행 중 요청 취소 + 마지막 입력만 통과".
  CancellableSearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancellableSearchProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancellableSearchHash();

  @$internal
  @override
  $FutureProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Post>> create(Ref ref) {
    return cancellableSearch(ref);
  }
}

String _$cancellableSearchHash() => r'f4b1b5cdc36cf514c61a7c526c2a86f09cd93b46';

/// dio 버전 취소 — riverpod 공식 pub 예제(examples/pub/lib/detail.dart)와 동일한 패턴.
///
/// http 의 Client.close() 대신, 요청에 CancelToken 을 연결하고 onDispose 에서 cancel() 한다.
/// CancelToken 은 "보내기 전/보낸 뒤"를 한 번에 처리한다:
///  - 대기 중 폐기되어 토큰이 이미 취소됐으면 dio.get 이 곧바로 DioException(type: cancel) 을 던진다(요청 생략).
///  - 전송 중 취소되면 진행 중 요청을 실제로 끊는다.

@ProviderFor(cancellableSearchDio)
final cancellableSearchDioProvider = CancellableSearchDioProvider._();

/// dio 버전 취소 — riverpod 공식 pub 예제(examples/pub/lib/detail.dart)와 동일한 패턴.
///
/// http 의 Client.close() 대신, 요청에 CancelToken 을 연결하고 onDispose 에서 cancel() 한다.
/// CancelToken 은 "보내기 전/보낸 뒤"를 한 번에 처리한다:
///  - 대기 중 폐기되어 토큰이 이미 취소됐으면 dio.get 이 곧바로 DioException(type: cancel) 을 던진다(요청 생략).
///  - 전송 중 취소되면 진행 중 요청을 실제로 끊는다.

final class CancellableSearchDioProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>
        >
    with $FutureModifier<List<Post>>, $FutureProvider<List<Post>> {
  /// dio 버전 취소 — riverpod 공식 pub 예제(examples/pub/lib/detail.dart)와 동일한 패턴.
  ///
  /// http 의 Client.close() 대신, 요청에 CancelToken 을 연결하고 onDispose 에서 cancel() 한다.
  /// CancelToken 은 "보내기 전/보낸 뒤"를 한 번에 처리한다:
  ///  - 대기 중 폐기되어 토큰이 이미 취소됐으면 dio.get 이 곧바로 DioException(type: cancel) 을 던진다(요청 생략).
  ///  - 전송 중 취소되면 진행 중 요청을 실제로 끊는다.
  CancellableSearchDioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancellableSearchDioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancellableSearchDioHash();

  @$internal
  @override
  $FutureProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Post>> create(Ref ref) {
    return cancellableSearchDio(ref);
  }
}

String _$cancellableSearchDioHash() =>
    r'76fdc341576ded341a1741ffcb497da3268c8f95';
