import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/screens/login_page.dart';

void main() {
  testWidgets('LoginForm submits trimmed credentials', (tester) async {
    Credentials? submitted;

    await tester.pumpWidget(
      _TestApp(
        child: LoginForm(
          onLogIn: (credentials) async {
            submitted = credentials;
          },
          onSignUp: (_) async {},
        ),
      ),
    );

    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.byKey(LoginForm.emailFieldKey), findsOneWidget);
    expect(find.byKey(LoginForm.passwordFieldKey), findsOneWidget);

    await tester.enterText(
      find.byKey(LoginForm.emailFieldKey),
      '  driver@example.com  ',
    );
    await tester.enterText(find.byKey(LoginForm.passwordFieldKey), 'secret');
    await tester.tap(find.byKey(LoginForm.signInButtonKey));
    await tester.pumpAndSettle();

    expect(submitted?.username, 'driver@example.com');
    expect(submitted?.password, 'secret');
  });

  testWidgets('LoginForm shows loading state while submitting', (tester) async {
    final completer = Completer<void>();

    await tester.pumpWidget(
      _TestApp(
        child: LoginForm(
          onLogIn: (_) => completer.future,
          onSignUp: (_) async {},
        ),
      ),
    );

    await tester.tap(find.byKey(LoginForm.signInButtonKey));
    await tester.pump();

    expect(find.byKey(LoginForm.loadingIndicatorKey), findsOneWidget);

    completer.complete();
    await tester.pumpAndSettle();

    expect(find.byKey(LoginForm.loadingIndicatorKey), findsNothing);
  });

  testWidgets('LoginForm displays callback errors', (tester) async {
    await tester.pumpWidget(
      _TestApp(
        child: LoginForm(
          onLogIn: (_) async {
            throw Exception('Email or password is invalid.');
          },
          onSignUp: (_) async {},
        ),
      ),
    );

    await tester.tap(find.byKey(LoginForm.signInButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(LoginForm.messagePanelKey), findsOneWidget);
    expect(find.text('Email or password is invalid.'), findsOneWidget);
  });

  testWidgets('LoginForm can submit account creation', (tester) async {
    Credentials? submitted;

    await tester.pumpWidget(
      _TestApp(
        child: LoginForm(
          onLogIn: (_) async {},
          onSignUp: (credentials) async {
            submitted = credentials;
          },
        ),
      ),
    );

    await tester.enterText(
      find.byKey(LoginForm.emailFieldKey),
      'new@example.com',
    );
    await tester.enterText(find.byKey(LoginForm.passwordFieldKey), 'secret');
    await tester.tap(find.byKey(LoginForm.createAccountButtonKey));
    await tester.pumpAndSettle();

    expect(submitted?.username, 'new@example.com');
    expect(submitted?.password, 'secret');
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 460,
            height: 620,
            child: child,
          ),
        ),
      ),
    );
  }
}
