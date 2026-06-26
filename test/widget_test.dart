// 앱 스모크 테스트: 앱이 정상 빌드되고 랜딩 페이지가 표시되는지 확인한다.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod3_tutorial_app/main.dart';

void main() {
  testWidgets('앱이 실행되고 랜딩 페이지가 보인다', (WidgetTester tester) async {
    // main() 이 하는 ProviderScope 래핑을 테스트에서도 동일하게 적용
    await tester.pumpWidget(const ProviderScope(child: RiverpodTutorialApp()));
    await tester.pumpAndSettle(); // 라우터/애니메이션 정착 대기

    // 랜딩 페이지의 제목이 보이는지 검증
    expect(find.text('Riverpod 3.3.2 심화 학습'), findsOneWidget);
  });
}
