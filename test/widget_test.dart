
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:incluniv/main.dart';

void main() {
  testWidgets(
    'Aplikasi IncluNiv berhasil dibuka',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const IncluNivApp(),
      );

      expect(
        find.byType(MaterialApp),
        findsOneWidget,
      );
    },
  );
}
