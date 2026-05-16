import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/models.dart';
import 'favourite_vehicle.dart';

abstract class FavouriteVehicleRepository {
  Stream<List<FavouriteVehicle>> watchFavourites();
  Future<void> addFavourite(Restaurant vehicle);
  Future<void> removeFavourite(String vehicleId);
}

class FirestoreFavouriteVehicleRepository
    implements FavouriteVehicleRepository {
  FirestoreFavouriteVehicleRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> _favouritesFor(String uid) {
    return _firestore.collection('users').doc(uid).collection('favourites');
  }

  String _requireUserId() {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('Sign in to save favourite vehicles.');
    }
    return user.uid;
  }

  @override
  Stream<List<FavouriteVehicle>> watchFavourites() {
    final uid = _requireUserId();
    return _favouritesFor(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FavouriteVehicle.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> addFavourite(Restaurant vehicle) async {
    final uid = _requireUserId();
    final favourite = FavouriteVehicle.fromRestaurant(vehicle);
    await _favouritesFor(uid).doc(vehicle.id).set(favourite.toJson());
  }

  @override
  Future<void> removeFavourite(String vehicleId) async {
    final uid = _requireUserId();
    await _favouritesFor(uid).doc(vehicleId).delete();
  }
}

class InMemoryFavouriteVehicleRepository implements FavouriteVehicleRepository {
  final Map<String, FavouriteVehicle> _favourites = {};
  final StreamController<List<FavouriteVehicle>> _controller =
      StreamController<List<FavouriteVehicle>>.broadcast();

  @override
  Stream<List<FavouriteVehicle>> watchFavourites() {
    Future<void>.microtask(_emit);
    return _controller.stream;
  }

  @override
  Future<void> addFavourite(Restaurant vehicle) async {
    _favourites[vehicle.id] = FavouriteVehicle.fromRestaurant(vehicle);
    _emit();
  }

  @override
  Future<void> removeFavourite(String vehicleId) async {
    _favourites.remove(vehicleId);
    _emit();
  }

  void _emit() {
    if (_controller.isClosed) {
      return;
    }
    _controller.add(List.unmodifiable(_favourites.values));
  }

  void dispose() {
    _controller.close();
  }
}
