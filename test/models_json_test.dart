import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/models/food_category.dart';
import 'package:yummy/models/post.dart';
import 'package:yummy/models/restaurant.dart';

void main() {
  group('JSON serialization', () {
    test('FoodCategory fromJson/toJson roundtrip', () {
      final original = FoodCategory('Economy', 5, 'https://example.com/car.jpg');
      final encoded = original.toJson();
      final decoded = FoodCategory.fromJson(encoded);

      expect(decoded.name, original.name);
      expect(decoded.numberOfRestaurants, original.numberOfRestaurants);
      expect(decoded.imageUrl, original.imageUrl);
    });

    test('Post fromJson/toJson roundtrip', () {
      final original = Post('42', 'assets/me.png', 'Test comment', '12');
      final encoded = original.toJson();
      final decoded = Post.fromJson(encoded);

      expect(decoded.id, original.id);
      expect(decoded.profileImageUrl, original.profileImageUrl);
      expect(decoded.comment, original.comment);
      expect(decoded.timestamp, original.timestamp);
    });

    test('Item fromJson/toJson roundtrip', () {
      final original = Item(
        name: 'Extra driver',
        description: 'Second approved driver',
        price: 18,
        imageUrl: 'https://example.com/addon.jpg',
      );
      final encoded = original.toJson();
      final decoded = Item.fromJson(encoded);

      expect(decoded.name, original.name);
      expect(decoded.description, original.description);
      expect(decoded.price, original.price);
      expect(decoded.imageUrl, original.imageUrl);
    });

    test('Restaurant fromJson/toJson roundtrip', () {
      final original = Restaurant(
        '7',
        'Honda Accord',
        'Baiterek Tower Hub, Astana',
        'Comfort, roomy cabin',
        'https://example.com/car.jpg',
        'https://example.com/credits',
        1.2,
        4.8,
        [
          Item(
            name: 'Unlimited local miles',
            description: 'No local mileage cap',
            price: 20,
            imageUrl: 'https://example.com/miles.jpg',
          ),
        ],
        vehicleClass: 'Comfort',
        hourlyRate: 19,
      );

      final encoded = original.toJson();
      final decoded = Restaurant.fromJson(encoded);

      expect(decoded.id, original.id);
      expect(decoded.name, original.name);
      expect(decoded.address, original.address);
      expect(decoded.attributes, original.attributes);
      expect(decoded.imageUrl, original.imageUrl);
      expect(decoded.imageCredits, original.imageCredits);
      expect(decoded.distance, original.distance);
      expect(decoded.rating, original.rating);
      expect(decoded.vehicleClass, original.vehicleClass);
      expect(decoded.hourlyRate, original.hourlyRate);
      expect(decoded.items.length, 1);
      expect(decoded.items.first.name, 'Unlimited local miles');
    });
  });
}
