// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debounce_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 검색어 상태.

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// 검색어 상태.
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// 검색어 상태.
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'0bcdb7b716d24a9fc2ff883805b98eec70434183';

/// 검색어 상태.

abstract class _$SearchQuery extends $Notifier<String> {
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

/// 디바운스 검색 결과.
///
/// 동작 원리:
///  - searchQuery 를 watch → 입력이 바뀔 때마다 이 build 가 재실행된다.
///  - 재실행 시 이전 build 는 폐기되어 onDispose 가 호출된다(취소 지점).
///  - 400ms 대기 후 실제 검색 → 빠르게 타이핑하면 마지막 입력만 통과(디바운스).

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// 디바운스 검색 결과.
///
/// 동작 원리:
///  - searchQuery 를 watch → 입력이 바뀔 때마다 이 build 가 재실행된다.
///  - 재실행 시 이전 build 는 폐기되어 onDispose 가 호출된다(취소 지점).
///  - 400ms 대기 후 실제 검색 → 빠르게 타이핑하면 마지막 입력만 통과(디바운스).

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Post>>,
          List<Post>,
          FutureOr<List<Post>>
        >
    with $FutureModifier<List<Post>>, $FutureProvider<List<Post>> {
  /// 디바운스 검색 결과.
  ///
  /// 동작 원리:
  ///  - searchQuery 를 watch → 입력이 바뀔 때마다 이 build 가 재실행된다.
  ///  - 재실행 시 이전 build 는 폐기되어 onDispose 가 호출된다(취소 지점).
  ///  - 400ms 대기 후 실제 검색 → 빠르게 타이핑하면 마지막 입력만 통과(디바운스).
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Post>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Post>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'73293f5da7c2905547eeb6aed38287511443268b';
