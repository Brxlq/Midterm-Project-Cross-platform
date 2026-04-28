import 'dart:async';
import 'dart:collection';

class RecipeSearchHistoryStream {
  RecipeSearchHistoryStream({this.maxItems = 8});

  final int maxItems;
  final Queue<String> _history = Queue<String>();
  final StreamController<List<String>> _controller =
      StreamController<List<String>>.broadcast();

  Stream<List<String>> get stream => _controller.stream;

  List<String> get current => List.unmodifiable(_history);

  void addQuery(String query) {
    final normalized = query.trim();
    if (normalized.isEmpty) {
      return;
    }

    _history.removeWhere(
      (existing) => existing.toLowerCase() == normalized.toLowerCase(),
    );
    _history.addFirst(normalized);
    while (_history.length > maxItems) {
      _history.removeLast();
    }
    _controller.add(List.unmodifiable(_history));
  }

  void dispose() {
    _controller.close();
  }
}
