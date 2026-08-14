import 'package:flutter_test/flutter_test.dart';
import 'package:trading_education_app/services/program_service.dart';

void main() {
  group('ProgramService', () {
    test('expectedLessonsByDay scales linearly', () {
      expect(ProgramService.expectedLessonsByDay(1, 30), 1);
      expect(ProgramService.expectedLessonsByDay(15, 30), 15);
      expect(ProgramService.expectedLessonsByDay(30, 30), 30);
    });

    test('isOnTrack compares completed vs expected', () {
      expect(ProgramService.isOnTrack(10, 10, 30), true);
      expect(ProgramService.isOnTrack(5, 10, 30), false);
    });
  });
}
