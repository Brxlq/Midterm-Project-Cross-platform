import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/models.dart';
import 'favourite_vehicle.dart';
import 'favourite_vehicle_repository.dart';

class FavouriteVehicleManager extends ChangeNotifier {
  FavouriteVehicleManager(this._repository);

  final FavouriteVehicleRepository _repository;

  StreamSubscription<List<FavouriteVehicle>>? _subscription;
  List<FavouriteVehicle> _favourites = const [];
  bool _loading = false;
  String? _error;

  List<FavouriteVehicle> get favourites => List.unmodifiable(_favourites);
  bool get loading => _loading;
  String? get error => _error;

  void start() {
    _subscription?.cancel();
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _subscription = _repository.watchFavourites().listen(
        (favourites) {
          _favourites = favourites;
          _loading = false;
          _error = null;
          notifyListeners();
        },
        onError: (Object error) {
          _loading = false;
          _error = error.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      _loading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isFavourite(String vehicleId) {
    return _favourites.any((vehicle) => vehicle.vehicleId == vehicleId);
  }

  Future<void> toggleFavourite(Restaurant vehicle) async {
    try {
      _error = null;
      if (isFavourite(vehicle.id)) {
        await _repository.removeFavourite(vehicle.id);
      } else {
        await _repository.addFavourite(vehicle);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    if (_repository is InMemoryFavouriteVehicleRepository) {
      (_repository as InMemoryFavouriteVehicleRepository).dispose();
    }
    super.dispose();
  }
}
