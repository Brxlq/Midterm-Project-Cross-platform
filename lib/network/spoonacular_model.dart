class RecipeSearchRequest {
  const RecipeSearchRequest({
    required this.query,
    this.number = 10,
    this.cuisine,
    this.diet,
    this.addRecipeInformation = false,
  });

  final String query;
  final int number;
  final String? cuisine;
  final String? diet;
  final bool addRecipeInformation;
}

class SpoonacularRecipe {
  const SpoonacularRecipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.imageType = '',
  });

  final int id;
  final String title;
  final String imageUrl;
  final String imageType;

  factory SpoonacularRecipe.fromJson(Map<String, dynamic> json) {
    return SpoonacularRecipe(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      imageType: json['imageType'] as String? ?? '',
    );
  }
}
