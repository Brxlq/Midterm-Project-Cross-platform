import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';

class FavouriteVehicle {
  const FavouriteVehicle({
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImageUrl,
    required this.vehicleClass,
    required this.hourlyRate,
    required this.createdAt,
  });

  final String vehicleId;
  final String vehicleName;
  final String vehicleImageUrl;
  final String vehicleClass;
  final double hourlyRate;
  final DateTime createdAt;

  factory FavouriteVehicle.fromRestaurant(Restaurant vehicle) {
    return FavouriteVehicle(
      vehicleId: vehicle.id,
      vehicleName: vehicle.name,
      vehicleImageUrl: vehicle.imageUrl,
      vehicleClass: vehicle.vehicleClass,
      hourlyRate: vehicle.hourlyRate,
      createdAt: DateTime.now(),
    );
  }

  factory FavouriteVehicle.fromJson(Map<String, dynamic> json) {
    final created = json['createdAt'];
    var createdAt = DateTime.now();
    if (created is Timestamp) {
      createdAt = created.toDate();
    } else if (created is String) {
      createdAt = DateTime.tryParse(created) ?? DateTime.now();
    }

    return FavouriteVehicle(
      vehicleId: json['vehicleId'] as String? ?? '',
      vehicleName: json['vehicleName'] as String? ?? '',
      vehicleImageUrl: json['vehicleImageUrl'] as String? ?? '',
      vehicleClass: json['vehicleClass'] as String? ?? '',
      hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'vehicleId': vehicleId,
        'vehicleName': vehicleName,
        'vehicleImageUrl': vehicleImageUrl,
        'vehicleClass': vehicleClass,
        'hourlyRate': hourlyRate,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
