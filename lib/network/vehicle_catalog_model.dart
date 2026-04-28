class VehicleMake {
  const VehicleMake({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory VehicleMake.fromJson(Map<String, dynamic> json) {
    return VehicleMake(
      id: (json['Make_ID'] as num?)?.toInt() ?? 0,
      name: json['Make_Name'] as String? ?? '',
    );
  }
}

class VehicleCatalogResponse {
  const VehicleCatalogResponse({
    required this.results,
    required this.totalResults,
  });

  final List<VehicleMake> results;
  final int totalResults;

  factory VehicleCatalogResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['Results'] as List<dynamic>? ?? [];
    final parsed = rawResults
        .whereType<Map>()
        .map((entry) => VehicleMake.fromJson(Map<String, dynamic>.from(entry)))
        .toList();

    return VehicleCatalogResponse(
      results: parsed,
      totalResults: (json['Count'] as num?)?.toInt() ?? parsed.length,
    );
  }
}
