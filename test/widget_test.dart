import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:trading_education_app/app.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const TradeMasterApp());
    await tester.pump();
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
