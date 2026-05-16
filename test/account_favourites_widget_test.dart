import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/favourites/favourites.dart';
import 'package:yummy/models/models.dart';
import 'package:yummy/screens/account_page.dart';

void main() {
  testWidgets('AccountPage renders saved favourite vehicles', (tester) async {
    String? openedVehicleId;

    await tester.pumpWidget(
      MaterialApp(
        home: AccountPage(
          user: _user,
          favouriteVehicles: [
            FavouriteVehicle(
              vehicleId: '15',
              vehicleName: 'Tesla Model 3',
              vehicleImageUrl: 'https://example.com/tesla.jpg',
              vehicleClass: 'Electric',
              hourlyRate: 27,
              createdAt: DateTime(2026, 5, 15),
            ),
          ],
          onOpenFavouriteVehicle: (vehicleId) {
            openedVehicleId = vehicleId;
          },
          onOpenSupportChat: () {},
          onLogOut: (_) {},
        ),
      ),
    );

    expect(find.text('Favourite vehicles'), findsOneWidget);
    expect(find.text('Tesla Model 3'), findsOneWidget);
    expect(find.text('Electric | \$27/hr'), findsOneWidget);

    await tester.tap(find.text('Tesla Model 3'));
    await tester.pump();

    expect(openedVehicleId, '15');
  });

  testWidgets('AccountPage renders favourites empty state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AccountPage(
          user: _user,
          onOpenFavouriteVehicle: (_) {},
          onOpenSupportChat: () {},
          onLogOut: (_) {},
        ),
      ),
    );

    expect(find.text('No favourite vehicles yet.'), findsOneWidget);
  });
}

final _user = User(
  firstName: 'Yerkebulan',
  lastName: 'Sovet',
  role: 'Echelon Member',
  profileImageUrl: 'assets/yummy_logo.png',
  points: 2400,
  darkMode: true,
);
