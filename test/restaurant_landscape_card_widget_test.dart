import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/components/components.dart';
import 'package:yummy/models/models.dart';

void main() {
  testWidgets('vehicle card shows favourite state and toggles', (
    tester,
  ) async {
    var toggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 270,
            child: RestaurantLandscapeCard(
              restaurant: _vehicle,
              isFavourite: false,
              onFavouriteToggle: () async {
                toggled = true;
              },
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    expect(toggled, isTrue);
  });

  testWidgets('vehicle card shows filled heart when favourited', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            height: 270,
            child: RestaurantLandscapeCard(
              restaurant: _vehicle,
              isFavourite: true,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
  });
}

final _vehicle = Restaurant(
  '15',
  'Tesla Model 3',
  'Green Quarter Hub, Astana',
  'Electric, autopilot, fast charging',
  'https://example.com/tesla.jpg',
  'credits',
  0.5,
  4.8,
  const [],
  vehicleClass: 'Electric',
  hourlyRate: 27,
);
