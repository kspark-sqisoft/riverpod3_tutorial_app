import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';

/// 화면 로그에 표시할 때 색상/필터를 구분하기 위한 로그 레벨 태그.
enum LogTag { trace, debug, info, warning, error }

/// 한 줄의 로그 기록(레벨 + 메시지 + 시각). 화면 리스트에 그대로 그린다.
@immutable
class LogEntry {
  const LogEntry(this.tag, this.message, this.time);

  final LogTag tag; // 로그 레벨(색상 구분용)
  final String message; // 학습용 서술형 한국어 메시지
  final DateTime time; // 발생 시각(HH:mm:ss.SSS 로 표시)
}

/// 학습용 로거.
///
/// 단일 sink로 두 곳에 동시에 출력한다.
///   1) 콘솔: `logger` 패키지의 PrettyPrinter 로 보기 좋게
///   2) 화면: [entries]( ValueNotifier )에 쌓아 `LifecycleLogView` 가 구독
///
/// provider 의 build/dispose, 비동기 상태 전이, 라이프사이클 콜백, DI resolve 순서를
/// 서술형 한국어로 남겨, 코드를 "한 줄씩 읽으며" 동작을 따라갈 수 있게 한다.
class AppLogger {
  AppLogger._(); // private 생성자 — 외부에서 새로 만들지 못하게
  static final AppLogger instance = AppLogger._(); // 앱 전역에서 공유하는 단일 인스턴스

  // 콘솔 출력기. methodCount:0 → 스택 트레이스 없이 메시지만 깔끔하게.
  final Logger _logger = Logger(printer: SimplePrinter(printTime: true));

  /// 화면 표시용 인메모리 로그 버퍼. 위젯은 ValueListenableBuilder 로 구독한다.
  final ValueNotifier<List<LogEntry>> entries = ValueNotifier<List<LogEntry>>(
    <LogEntry>[],
  );

  static const int _maxEntries = 300; // 너무 길어지지 않도록 최근 300개만 유지

  final List<LogEntry> _all = <LogEntry>[]; // 동기적으로 쌓는 원본 버퍼
  bool _flushScheduled = false; // 프레임 후 반영이 이미 예약됐는지

  // 콘솔과 화면 버퍼에 동시에 기록하는 내부 공통 로직.
  void _emit(LogTag tag, String message) {
    // 원본 버퍼에는 항상 즉시 쌓는다(순서 보존).
    _all.add(LogEntry(tag, message, DateTime.now()));
    if (_all.length > _maxEntries) {
      _all.removeRange(0, _all.length - _maxEntries); // 오래된 항목부터 버림
    }
    _scheduleFlush();
  }

  // entries(ValueNotifier) 갱신을 "빌드 단계 밖"에서만 한다.
  //
  // provider 가 빌드 중 생성되며 log 를 남기면(예: ProviderObserver),
  // 빌드 도중 ValueNotifier 를 갱신하게 되어 "setState during build" 예외가 난다.
  // 따라서 빌드/레이아웃 단계면 다음 프레임 뒤로 미뤄 알린다.
  void _scheduleFlush() {
    SchedulerBinding? binding;
    try {
      binding = SchedulerBinding.instance;
    } catch (_) {
      binding = null; // Flutter 바인딩이 없는 순수 단위 테스트 등
    }
    final phase = binding?.schedulerPhase;
    if (binding == null || phase == SchedulerPhase.idle) {
      // 이벤트 콜백/유휴 상태 → 즉시 반영해도 안전
      entries.value = List<LogEntry>.of(_all);
    } else if (!_flushScheduled) {
      // 빌드/레이아웃/페인트 중 → 프레임 종료 후 한 번에 반영
      _flushScheduled = true;
      binding.addPostFrameCallback((_) {
        _flushScheduled = false;
        entries.value = List<LogEntry>.of(_all);
      });
    }
  }

  void t(String m) {
    _logger.t(m); // trace: 가장 상세(예: build 시작, 인자)
    _emit(LogTag.trace, m);
  }

  void d(String m) {
    _logger.d(m); // debug: 상태 전이
    _emit(LogTag.debug, m);
  }

  void i(String m) {
    _logger.i(m); // info: 주요 이벤트(dispose, 네트워크 완료 등)
    _emit(LogTag.info, m);
  }

  void w(String m) {
    _logger.w(m); // warning: 취소/재시도 등 주의할 흐름
    _emit(LogTag.warning, m);
  }

  void e(String m) {
    _logger.e(m); // error: providerDidFail 등 실패
    _emit(LogTag.error, m);
  }

  /// 화면 로그 비우기(데모 초기화용).
  void clear() {
    _all.clear();
    entries.value = <LogEntry>[];
  }
}

/// 어디서든 `log.i('...')` 처럼 짧게 쓰기 위한 최상위 단축 참조.
final AppLogger log = AppLogger.instance;
