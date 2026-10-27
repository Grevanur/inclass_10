import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';

void main() {
  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('empty form shows all required validation messages', (
    tester,
  ) async {
    await tester.pumpWidget(const CosmicGuildApp());
    await tester.tap(find.byKey(const Key('signupButton')));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
  });

  testWidgets('invalid email and short password are rejected', (tester) async {
    await tester.pumpWidget(const CosmicGuildApp());
    await tester.enterText(find.byKey(const Key('nameField')), 'Gowtham');
    await tester.enterText(find.byKey(const Key('emailField')), 'invalid');
    await tester.enterText(find.byKey(const Key('passwordField')), '12345');
    await scrollTo(tester, find.byKey(const Key('signupButton')));
    await tester.tap(find.byKey(const Key('signupButton')));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });

  testWidgets('valid form shows success feedback', (tester) async {
    await tester.pumpWidget(const CosmicGuildApp());
    await tester.enterText(find.byKey(const Key('nameField')), 'Gowtham');
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'gowtham@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'orbit123');
    await scrollTo(tester, find.byKey(const Key('signupButton')));
    await tester.tap(find.byKey(const Key('signupButton')));
    await tester.pump();

    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsOneWidget,
    );
  });

  testWidgets('password coach displays all three transparent states', (
    tester,
  ) async {
    await tester.pumpWidget(const CosmicGuildApp());
    expect(find.textContaining('Not entered'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('passwordField')), 'short');
    await tester.pump();
    expect(find.textContaining('Needs more length'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('passwordField')), 'longpass');
    await tester.pump();
    expect(find.textContaining('Meets demo length rule'), findsOneWidget);
  });

  testWidgets('preset tip succeeds without form values', (tester) async {
    await tester.pumpWidget(const CosmicGuildApp());
    await scrollTo(tester, find.byKey(const Key('tipButton')));
    await tester.tap(find.byKey(const Key('tipButton')));
    await tester.pump();
    expect(find.text('Loading a preset tip…'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Preset demo tip—not live AI.'), findsOneWidget);
    final tip = tester.widget<Text>(
      find.textContaining('Use a long, unique passphrase'),
    );
    expect(tip.data!.length, lessThanOrEqualTo(240));
  });

  testWidgets('missing tip data shows error and retry recovers', (
    tester,
  ) async {
    await tester.pumpWidget(const CosmicGuildApp());
    await scrollTo(tester, find.byKey(const Key('missingDataButton')));
    await tester.tap(find.byKey(const Key('missingDataButton')));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Preset tip data is empty or missing.'), findsOneWidget);
    await scrollTo(tester, find.byKey(const Key('retryButton')));
    await tester.tap(find.byKey(const Key('retryButton')));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Preset demo tip—not live AI.'), findsOneWidget);
  });
}
