import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/models.dart';
import 'package:yummy/screens/account_page.dart';

void main() {
  testWidgets('AccountPage renders member details and callbacks', (
    tester,
  ) async {
    var openedSupport = false;
    var loggedOut = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AccountPage(
          user: User(
            firstName: 'Yerkebulan',
            lastName: 'Sovet',
            role: 'Echelon Member',
            profileImageUrl: 'assets/yummy_logo.png',
            points: 2400,
            darkMode: true,
          ),
          onOpenSupportChat: () {
            openedSupport = true;
          },
          onOpenFavouriteVehicle: (_) {},
          onLogOut: (didLogout) {
            loggedOut = didLogout;
          },
        ),
      ),
    );

    expect(find.text('Yerkebulan Sovet'), findsOneWidget);
    expect(find.text('Echelon Member'), findsOneWidget);
    expect(find.text('2400 member points'), findsOneWidget);
    expect(find.text('Echelon Plus'), findsOneWidget);
    expect(find.text('No favourite vehicles yet.'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -320));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AccountPage.supportTileKey));
    await tester.pump();
    expect(openedSupport, isTrue);

    await tester.drag(find.byType(ListView), const Offset(0, -120));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(AccountPage.logoutTileKey));
    await tester.pump();
    expect(loggedOut, isTrue);
  });
}
