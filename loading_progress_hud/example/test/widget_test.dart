// import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final Finder login = find.byType(RaisedButton);
  group('App', () {
    testWidgets('App smoke test', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(new MyApp());
      expect(find.byType(TestLoadingPage), findsOneWidget);
    });
  });
}
