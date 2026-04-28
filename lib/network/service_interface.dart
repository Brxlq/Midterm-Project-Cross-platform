import 'model_response.dart';
import 'query_result.dart';
import 'spoonacular_model.dart';

abstract class RecipeServiceInterface {
  Future<QueryResult<SpoonacularModelResponse>> searchRecipes(
    RecipeSearchRequest request,
  );
}
