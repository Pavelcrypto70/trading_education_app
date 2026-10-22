import 'package:flutter_test/flutter_test.dart';
import 'package:trading_education_app/services/desk_key_service.dart';

void main() {
  test('key code matches tools/desk_key_code.py', () {
    expect(DeskKeyService.expectedCode('TM-12345', 'test-salt'), '5073-49C8');
  });

  test('Tiger User ID format', () {
    expect(DeskKeyService.isValidUid('12345678'), isTrue);
    expect(DeskKeyService.isValidUid(' 1234 5678 '), isTrue);
    expect(DeskKeyService.isValidUid('123'), isFalse);
    expect(DeskKeyService.isValidUid('12345-678'), isFalse);
  });
}
