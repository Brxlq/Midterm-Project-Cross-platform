import 'spoonacular_model.dart';

class SpoonacularModelResponse {
  const SpoonacularModelResponse({
    required this.results,
    required this.totalResults,
  });

  final List<SpoonacularRecipe> results;
  final int totalResults;

  factory SpoonacularModelResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'] as List<dynamic>? ?? [];
    final parsedResults = rawResults
        .whereType<Map>()
        .map(
          (entry) => SpoonacularRecipe.fromJson(
            Map<String, dynamic>.from(entry),
          ),
        )
        .toList();

    return SpoonacularModelResponse(
      results: parsedResults,
      totalResults: (json['totalResults'] as num?)?.toInt() ?? 0,
    );
  }
}
