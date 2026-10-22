import 'progress_service.dart';

/// What the simulator shows depends on what the course has already explained.
enum SimLevel {
  /// Lesson 13 (plan of a deal) not finished yet: simulator stays closed.
  locked,
  /// Lessons 14–37: buy only, amount in USDT, stop and take.
  spot,
  /// Lessons 38–46: buy only, size from «риск на сделку».
  spotRisk,
  /// Lessons 47+: long and short; leverage 1–3 from 48, liquidation price from 49.
  futures,
}

class SimMode {
  SimMode._();

  static const firstOpenLesson = 14;

  /// Lesson from which each simulator element may appear (term explained there).
  static const riskFrom = 38;
  static const ratioFrom = 40;
  static const breakevenFrom = 44;
  static const stopDayFrom = 45;
  /// «Крупные свечи» toggle: the higher timeframe is explained in lesson 25.
  static const bigCandlesFrom = 25;
  /// Lesson 47 explains long and short; leverage comes one lesson later.
  static const futuresFrom = 47;
  static const leverageFrom = 48;
  static const liquidationFrom = 49;
  static const isolatedFrom = 50;
  /// Lesson 53 explains the exchange fee: from here the simulator charges it.
  static const feeFrom = 53;
  static const feeRate = 0.0005;

  static SimLevel forLesson(int lessonId) {
    if (lessonId >= futuresFrom) return SimLevel.futures;
    if (lessonId >= 38) return SimLevel.spotRisk;
    if (lessonId >= firstOpenLesson) return SimLevel.spot;
    return SimLevel.locked;
  }

  /// Level for free practice (no lesson context): the lesson the user is on now.
  static Future<int> reachedLesson() async {
    final done = await ProgressService.getCompletedLessons();
    var next = 1;
    while (done.contains(next)) {
      next++;
    }
    return next;
  }
}
