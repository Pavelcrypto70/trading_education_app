import 'package:flutter_test/flutter_test.dart';
import 'package:trading_education_app/config/app_config.dart';

void main() {
  test('trial lessons are conversion-focused set', () {
    expect(AppConfig.trialLessonIds, containsAll([1, 2, 3, 7, 10]));
    expect(AppConfig.trialLessonIds.length, 5);
  });

  test('lifetime product id is stable', () {
    expect(AppConfig.lifetimeProductId, 'trade_master_lifetime_full');
  });
}
