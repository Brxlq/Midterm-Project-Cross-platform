import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/favourites/favourites.dart';
import 'package:yummy/models/models.dart';

void main() {
  test('manager toggles favourite vehicles through repository', () async {
    final repository = _FakeFavouriteVehicleRepository();
    final manager = FavouriteVehicleManager(repository)..start();
    addTearDown(manager.dispose);

    await _waitFor(() => manager.loading == false);
    expect(manager.favourites, isEmpty);

    await manager.toggleFavourite(_vehicle);
    await _waitFor(() => manager.isFavourite(_vehicle.id));

    expect(repository.addedIds, ['15']);
    expect(manager.favourites.single.vehicleName, 'Tesla Model 3');

    await manager.toggleFavourite(_vehicle);
    await _waitFor(() => !manager.isFavourite(_vehicle.id));

    expect(repository.removedIds, ['15']);
    expect(manager.favourites, isEmpty);
  });

  test('manager captures repository failures', () async {
    final repository = _FailingFavouriteVehicleRepository();
    final manager = FavouriteVehicleManager(repository)..start();
    addTearDown(manager.dispose);

    await _waitFor(() => manager.error != null);

    expect(manager.loading, isFalse);
    expect(manager.error, contains('Firestore unavailable'));
  });
}

final _vehicle = Restaurant(
  '15',
  'Tesla Model 3',
  'Green Quarter Hub, Astana',
  'Electric',
  'https://example.com/tesla.jpg',
  'credits',
  0.5,
  4.8,
  const [],
  vehicleClass: 'Electric',
  hourlyRate: 27,
);

Future<void> _waitFor(bool Function() condition) async {
  for (var i = 0; i < 20; i += 1) {
    if (condition()) {
      return;
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  throw StateError('Condition was not met in time.');
}

class _FakeFavouriteVehicleRepository implements FavouriteVehicleRepository {
  final Map<String, FavouriteVehicle> favourites = {};
  final List<String> addedIds = [];
  final List<String> removedIds = [];
  final StreamController<List<FavouriteVehicle>> controller =
      StreamController<List<FavouriteVehicle>>.broadcast();

  @override
  Future<void> addFavourite(Restaurant vehicle) async {
    addedIds.add(vehicle.id);
    favourites[vehicle.id] = FavouriteVehicle.fromRestaurant(vehicle);
    controller.add(List.unmodifiable(favourites.values));
  }

  @override
  Future<void> removeFavourite(String vehicleId) async {
    removedIds.add(vehicleId);
    favourites.remove(vehicleId);
    controller.add(List.unmodifiable(favourites.values));
  }

  @override
  Stream<List<FavouriteVehicle>> watchFavourites() {
    Future<void>.microtask(() {
      controller.add(List.unmodifiable(favourites.values));
    });
    return controller.stream;
  }
}

class _FailingFavouriteVehicleRepository implements FavouriteVehicleRepository {
  @override
  Future<void> addFavourite(Restaurant vehicle) async {}

  @override
  Future<void> removeFavourite(String vehicleId) async {}

  @override
  Stream<List<FavouriteVehicle>> watchFavourites() {
    throw StateError('Firestore unavailable');
  }
}
