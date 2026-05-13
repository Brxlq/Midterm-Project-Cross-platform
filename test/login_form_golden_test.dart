import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/screens/login_page.dart';

void main() {
  testWidgets('LoginForm golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF0F62FE),
          useMaterial3: true,
        ),
        home: Scaffold(
          backgroundColor: const Color(0xFFF3F7FB),
          body: Center(
            child: SizedBox(
              width: 460,
              height: 620,
              child: RepaintBoundary(
                child: LoginForm(
                  onLogIn: (_) async {},
                  onSignUp: (_) async {},
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(LoginForm),
      matchesGoldenFile('goldens/login_form.png'),
    );
  });
}
