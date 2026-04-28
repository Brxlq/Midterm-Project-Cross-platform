import 'package:flutter/foundation.dart';

import '../../learn/recipes/recipe_search_history_stream.dart';
import '../../network/query_result.dart';
import '../../network/vehicle_catalog_model.dart';
import '../../network/vehicle_catalog_service.dart';

class VehicleDiscoveryManager extends ChangeNotifier {
  VehicleDiscoveryManager({
    required VehicleCatalogService service,
    required RecipeSearchHistoryStream historyStream,
  })  : _service = service,
        _historyStream = historyStream;

  final VehicleCatalogService _service;
  final RecipeSearchHistoryStream _historyStream;

  bool _isLoading = false;
  QueryError? _error;
  List<VehicleMake> _allMakes = const [];
  List<VehicleMake> _visibleMakes = const [];
  String _query = '';

  bool get isLoading => _isLoading;
  QueryError? get error => _error;
  List<VehicleMake> get makes => List.unmodifiable(_visibleMakes);
  String get query => _query;
  Stream<List<String>> get recentQueries => _historyStream.stream;
  List<String> get currentRecentQueries => _historyStream.current;

  Future<void> loadCatalog() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _service.getMakes();
    if (result.isSuccess) {
      _allMakes = result.data?.results ?? const [];
      _applyQuery(_query);
      _error = null;
    } else {
      _allMakes = const [];
      _visibleMakes = const [];
      _error = result.error;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> search(String rawQuery) async {
    _query = rawQuery.trim();
    _applyQuery(_query);
    if (_query.isNotEmpty) {
      _historyStream.addQuery(_query);
    }
    notifyListeners();
  }

  Future<void> retry() async {
    await loadCatalog();
  }

  void _applyQuery(String query) {
    if (query.isEmpty) {
      _visibleMakes = _allMakes.take(24).toList();
      return;
    }
    final normalized = query.toLowerCase();
    _visibleMakes = _allMakes
        .where((make) => make.name.toLowerCase().contains(normalized))
        .take(24)
        .toList();
  }

  @override
  void dispose() {
    _historyStream.dispose();
    super.dispose();
  }
}
