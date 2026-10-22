import 'package:flutter_test/flutter_test.dart';
import 'package:trading_education_app/config/app_config.dart';

void main() {
  test('trial lesson ids kept for legacy UI badges only', () {
    expect(AppConfig.trialLessonIds, containsAll([1, 2, 3, 7, 10]));
    expect(AppConfig.trialLessonIds.length, 5);
  });
}
