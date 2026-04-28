import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/learn/recipes/recipe_search_history_stream.dart';

void main() {
  test('emits unique recent queries in expected order', () async {
    final history = RecipeSearchHistoryStream(maxItems: 3);
    final emissions = <List<String>>[];
    final sub = history.stream.listen(emissions.add);

    history.addQuery('pasta');
    history.addQuery('salad');
    history.addQuery('pasta');

    await Future<void>.delayed(Duration.zero);

    expect(emissions.last, ['pasta', 'salad']);
    expect(history.current, ['pasta', 'salad']);
    await sub.cancel();
    history.dispose();
  });

  test('trims to max size and supports multiple subscribers', () async {
    final history = RecipeSearchHistoryStream(maxItems: 2);
    final a = <List<String>>[];
    final b = <List<String>>[];
    final subA = history.stream.listen(a.add);
    final subB = history.stream.listen(b.add);

    history.addQuery('one');
    history.addQuery('two');
    history.addQuery('three');

    await Future<void>.delayed(Duration.zero);

    expect(history.current, ['three', 'two']);
    expect(a.isNotEmpty, isTrue);
    expect(b.isNotEmpty, isTrue);

    await subA.cancel();
    await subB.cancel();
    history.dispose();
  });
}
