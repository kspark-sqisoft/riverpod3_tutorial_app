import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/db_init.dart';
import 'app/lifecycle_observer.dart';
import 'app/router.dart';
import 'app/theme.dart';

void main() {
  // 위젯 바인딩 보장 후 DB factory 초기화(데스크톱은 sqflite ffi, 웹은 no-op).
  WidgetsFlutterBinding.ensureInitialized();
  initDatabaseFactory();
  runApp(
    // ProviderScope: 앱 전체 provider 의 루트 컨테이너(= DI 컨테이너).
    // observers 에 LifecycleObserver 를 등록하면 모든 provider 의
    // 생성/갱신/폐기/실패 이벤트가 콘솔과 화면 로그에 기록된다.
    const ProviderScope(
      observers: [LifecycleObserver()],
      child: RiverpodTutorialApp(),
    ),
  );
}

/// 루트 위젯. go_router 와 테마를 연결한다.
class RiverpodTutorialApp extends StatelessWidget {
  const RiverpodTutorialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Riverpod 3.3.2 학습',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter, // ShellRoute 기반 라우터
    );
  }
}
