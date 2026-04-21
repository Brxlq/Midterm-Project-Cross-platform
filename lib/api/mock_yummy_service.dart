import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/models.dart';

class ExploreData {
  final List<Restaurant> restaurants;
  final List<FoodCategory> categories;
  final List<Post> friendPosts;

  ExploreData(this.restaurants, this.categories, this.friendPosts);
}

class MockYummyService {
  static const _restaurantsPath = 'assets/data/restaurants.json';
  static const _categoriesPath = 'assets/data/categories.json';
  static const _postsPath = 'assets/data/posts.json';

  Future<ExploreData> getExploreData() async {
    try {
      final seedFleet = List<Restaurant>.from(restaurants);
      final seedCategories = List<FoodCategory>.from(categories);

      final restaurantsJson = await rootBundle.loadString(
        _restaurantsPath,
        cache: false,
      );
      final categoriesJson = await rootBundle.loadString(
        _categoriesPath,
        cache: false,
      );
      final postsJson = await rootBundle.loadString(
        _postsPath,
        cache: false,
      );

      final parsedRestaurants = _parseRestaurants(restaurantsJson);
      final parsedCategories = _parseCategories(categoriesJson);
      final parsedPosts = _parsePosts(postsJson);
      final normalizedRestaurants = _ensureMinimumFleet(
        parsedRestaurants,
        seedFleet,
      );
      final normalizedCategories = _normalizeCategories(
        parsedCategories,
        seedCategories,
        normalizedRestaurants,
      );

      restaurants = normalizedRestaurants;
      categories = normalizedCategories;
      posts = parsedPosts;

      return ExploreData(
        normalizedRestaurants,
        normalizedCategories,
        parsedPosts,
      );
    } catch (_) {
      restaurants = [];
      categories = [];
      posts = [];
      return ExploreData([], [], []);
    }
  }

  List<Restaurant> _parseRestaurants(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .whereType<Map>()
        .map((entry) => Restaurant.fromJson(Map<String, dynamic>.from(entry)))
        .toList();
  }

  List<FoodCategory> _parseCategories(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .whereType<Map>()
        .map((entry) => FoodCategory.fromJson(Map<String, dynamic>.from(entry)))
        .toList();
  }

  List<Post> _parsePosts(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .whereType<Map>()
        .map((entry) => Post.fromJson(Map<String, dynamic>.from(entry)))
        .toList();
  }

  List<Restaurant> _ensureMinimumFleet(
    List<Restaurant> parsedRestaurants,
    List<Restaurant> seedFleet,
  ) {
    final merged = List<Restaurant>.from(parsedRestaurants);
    final existingIds = merged.map((r) => r.id).toSet();
    const targetPerClass = 5;
    final classes = [
      economyClass,
      comfortClass,
      premiumClass,
      electricClass,
    ];

    for (final vehicleClass in classes) {
      final currentCount = merged
          .where((restaurant) => restaurant.vehicleClass == vehicleClass)
          .length;
      if (currentCount >= targetPerClass) {
        continue;
      }

      final needed = targetPerClass - currentCount;
      final fallbacks = seedFleet
          .where(
            (restaurant) =>
                restaurant.vehicleClass == vehicleClass &&
                !existingIds.contains(restaurant.id),
          )
          .take(needed);

      for (final restaurant in fallbacks) {
        merged.add(restaurant);
        existingIds.add(restaurant.id);
      }
    }

    return merged;
  }

  List<FoodCategory> _normalizeCategories(
    List<FoodCategory> parsedCategories,
    List<FoodCategory> seedCategories,
    List<Restaurant> allRestaurants,
  ) {
    if (allRestaurants.isEmpty) {
      return parsedCategories;
    }

    const classOrder = [
      economyClass,
      comfortClass,
      premiumClass,
      electricClass,
    ];

    String imageForClass(String vehicleClass) {
      for (final category in parsedCategories) {
        if (category.name == vehicleClass && category.imageUrl.isNotEmpty) {
          return category.imageUrl;
        }
      }
      for (final category in seedCategories) {
        if (category.name == vehicleClass && category.imageUrl.isNotEmpty) {
          return category.imageUrl;
        }
      }
      return '';
    }

    return classOrder.map((vehicleClass) {
      final count = allRestaurants
          .where((restaurant) => restaurant.vehicleClass == vehicleClass)
          .length;
      return FoodCategory(
        vehicleClass,
        count,
        imageForClass(vehicleClass),
      );
    }).toList();
  }
}
