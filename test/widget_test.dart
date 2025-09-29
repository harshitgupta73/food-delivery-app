// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:order_app/main.dart';
import 'package:order_app/src/repositories/restaurant_repository.dart';

void main() {
  testWidgets('App loads and shows restaurant list', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final repository = FakeRestaurantRepository();
    await tester.pumpWidget(MyApp(repository: repository));

    // Wait for the app to load
    await tester.pumpAndSettle();

    // Verify that the app loads and shows the restaurant list
    expect(find.text('Good morning! 👋'), findsOneWidget);
    expect(find.text('What would you like to order?'), findsOneWidget);
  });
}
