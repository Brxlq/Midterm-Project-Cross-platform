import 'package:flutter/foundation.dart';

import '../../network/query_result.dart';
import '../../network/service_interface.dart';
import '../../network/spoonacular_model.dart';
import 'recipe_search_history_stream.dart';

class RecipeSearchManager extends ChangeNotifier {
  RecipeSearchManager({
    required RecipeServiceInterface service,
    required RecipeSearchHistoryStream historyStream,
  })  : _service = service,
        _historyStream = historyStream;

  final RecipeServiceInterface _service;
  final RecipeSearchHistoryStream _historyStream;

  bool _isLoading = false;
  String _query = '';
  String? _diet;
  String? _cuisine;
  QueryError? _error;
  List<SpoonacularRecipe> _recipes = const [];

  bool get isLoading => _isLoading;
  String get query => _query;
  String? get diet => _diet;
  String? get cuisine => _cuisine;
  QueryError? get error => _error;
  List<SpoonacularRecipe> get recipes => List.unmodifiable(_recipes);
  Stream<List<String>> get recentQueries => _historyStream.stream;
  List<String> get currentRecentQueries => _historyStream.current;

  bool get hasResults => _recipes.isNotEmpty;

  Future<void> search(String rawQuery) async {
    final normalized = rawQuery.trim();
    _query = normalized;

    if (normalized.isEmpty) {
      _recipes = const [];
      _error = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _service.searchRecipes(
      RecipeSearchRequest(
        query: normalized,
        diet: _diet,
        cuisine: _cuisine,
      ),
    );

    if (result.isSuccess) {
      _recipes = result.data?.results ?? const [];
      _error = null;
      _historyStream.addQuery(normalized);
    } else {
      _recipes = const [];
      _error = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> retry() async {
    await search(_query);
  }

  void setDiet(String? value) {
    _diet = (value == null || value == 'Any') ? null : value;
    notifyListeners();
  }

  void setCuisine(String? value) {
    _cuisine = (value == null || value == 'Any') ? null : value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _historyStream.dispose();
    super.dispose();
  }
}
