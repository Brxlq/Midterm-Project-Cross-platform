import 'package:flutter/widgets.dart';

import 'recipe_search_manager.dart';

class RecipeSearchScope extends InheritedNotifier<RecipeSearchManager> {
  const RecipeSearchScope({
    super.key,
    required RecipeSearchManager manager,
    required super.child,
  }) : super(notifier: manager);

  static RecipeSearchManager of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<RecipeSearchScope>();
    assert(scope != null, 'RecipeSearchScope not found in widget tree.');
    return scope!.notifier!;
  }
}
