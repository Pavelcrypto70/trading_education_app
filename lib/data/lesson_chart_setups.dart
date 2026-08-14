import '../models/chart_setup.dart';
import 'lesson_chart_factory.dart';

/// Compatibility facade — every card gets a unique setup via [cardIndex].
class LessonChartSetups {
  LessonChartSetups._();

  static ChartSetup forLesson(int lessonId, String chartType, {int cardIndex = 0}) {
    return LessonChartFactory.forCard(
      lessonId: lessonId,
      cardIndex: cardIndex,
      chartType: chartType,
    );
  }

  static ChartSetup forChartType(String chartType, {int cardIndex = 0}) {
    return LessonChartFactory.forCard(
      lessonId: 0,
      cardIndex: cardIndex,
      chartType: chartType,
    );
  }

  static ChartSetup forCard({
    required int lessonId,
    required int cardIndex,
    String chartType = 'candlestick',
  }) {
    return LessonChartFactory.forCard(
      lessonId: lessonId,
      cardIndex: cardIndex,
      chartType: chartType,
    );
  }
}
