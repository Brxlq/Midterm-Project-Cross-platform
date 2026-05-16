import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/favourites/favourites.dart';
import 'package:yummy/models/models.dart';

void main() {
  test('FavouriteVehicle json roundtrip keeps fields', () {
    final favourite = FavouriteVehicle(
      vehicleId: '15',
      vehicleName: 'Tesla Model 3',
      vehicleImageUrl: 'https://example.com/tesla.jpg',
      vehicleClass: 'Electric',
      hourlyRate: 27,
      createdAt: DateTime(2026, 5, 15, 12),
    );

    final decoded = FavouriteVehicle.fromJson(favourite.toJson());

    expect(decoded.vehicleId, favourite.vehicleId);
    expect(decoded.vehicleName, favourite.vehicleName);
    expect(decoded.vehicleImageUrl, favourite.vehicleImageUrl);
    expect(decoded.vehicleClass, favourite.vehicleClass);
    expect(decoded.hourlyRate, favourite.hourlyRate);
  });

  test('FavouriteVehicle can be created from Restaurant', () {
    final vehicle = Restaurant(
      '1',
      'Toyota Corolla',
      'Astana Hub',
      'Economy',
      'https://example.com/car.jpg',
      'credits',
      1,
      4.7,
      const [],
      vehicleClass: 'Economy',
      hourlyRate: 14,
    );

    final favourite = FavouriteVehicle.fromRestaurant(vehicle);

    expect(favourite.vehicleId, '1');
    expect(favourite.vehicleName, 'Toyota Corolla');
    expect(favourite.vehicleClass, 'Economy');
    expect(favourite.hourlyRate, 14);
  });
}
