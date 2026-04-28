import 'package:flutter/material.dart';

import '../../network/spoonacular_service.dart';
import 'recipe_search_history_stream.dart';
import 'recipe_search_manager.dart';
import 'recipe_search_scope.dart';

class RecipeLearningPage extends StatefulWidget {
  const RecipeLearningPage({super.key});

  @override
  State<RecipeLearningPage> createState() => _RecipeLearningPageState();
}

class _RecipeLearningPageState extends State<RecipeLearningPage> {
  late final RecipeSearchManager _manager;
  final TextEditingController _searchController = TextEditingController();

  static const _dietOptions = <String>['Any', 'Vegetarian', 'Vegan', 'Paleo'];
  static const _cuisineOptions = <String>[
    'Any',
    'Italian',
    'Mexican',
    'Japanese',
    'American',
  ];

  @override
  void initState() {
    super.initState();
    _manager = RecipeSearchManager(
      service: SpoonacularService(),
      historyStream: RecipeSearchHistoryStream(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecipeSearchScope(
      manager: _manager,
      child: AnimatedBuilder(
        animation: _manager,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Recipe Learning Lab'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSearchControls(context),
                const SizedBox(height: 16),
                _buildRecentQueryStream(),
                const SizedBox(height: 16),
                _buildStatusSection(),
                const SizedBox(height: 12),
                _buildResultsGrid(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchControls(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: _manager.search,
          decoration: InputDecoration(
            hintText: 'Search recipes (e.g. pasta)',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _manager.search(_searchController.text),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _DropdownFilter(
              label: 'Diet',
              value: _manager.diet ?? 'Any',
              options: _dietOptions,
              onChanged: (value) => _manager.setDiet(value),
            ),
            _DropdownFilter(
              label: 'Cuisine',
              value: _manager.cuisine ?? 'Any',
              options: _cuisineOptions,
              onChanged: (value) => _manager.setCuisine(value),
            ),
            FilledButton.icon(
              onPressed: _manager.isLoading
                  ? null
                  : () => _manager.search(_searchController.text),
              icon: const Icon(Icons.travel_explore),
              label: const Text('Search'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentQueryStream() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: StreamBuilder<List<String>>(
          stream: _manager.recentQueries,
          initialData: _manager.currentRecentQueries,
          builder: (context, snapshot) {
            final history = snapshot.data ?? const [];
            if (history.isEmpty) {
              return const Text('Recent stream: no searches yet');
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: history
                  .map(
                    (query) => ActionChip(
                      label: Text(query),
                      onPressed: () {
                        _searchController.text = query;
                        _manager.search(query);
                      },
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    if (_manager.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_manager.error != null) {
      return Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: ListTile(
          title: Text(_manager.error!.message),
          subtitle: Text('Type: ${_manager.error!.type.name}'),
          trailing: IconButton(
            tooltip: 'Retry',
            onPressed: _manager.retry,
            icon: const Icon(Icons.refresh),
          ),
        ),
      );
    }

    if (_manager.query.isEmpty) {
      return const Text('Start by searching for a recipe keyword.');
    }

    if (!_manager.hasResults) {
      return Text('No results found for "${_manager.query}".');
    }

    return Text(
      'Found ${_manager.recipes.length} recipes for "${_manager.query}".',
    );
  }

  Widget _buildResultsGrid() {
    if (!_manager.hasResults) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      itemCount: _manager.recipes.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final recipe = _manager.recipes[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: recipe.imageUrl.isEmpty
                    ? Container(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_outlined),
                      )
                    : Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  recipe.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DropdownFilter extends StatelessWidget {
  const _DropdownFilter({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: value,
      hint: Text(label),
      items: options
          .map(
            (option) => DropdownMenuItem<String>(
              value: option,
              child: Text(option),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
