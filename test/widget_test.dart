import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_calc/main.dart';

void main() {
  testWidgets('app boots and shows the converter', (WidgetTester tester) async {
    await tester.pumpWidget(const CurrencyCalcApp());

    expect(find.text('Currency Calc'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Converted amount'), findsOneWidget);
    expect(find.text('92.00 EUR'), findsOneWidget);
  });
}
