import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/api/mock_yummy_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const assetsChannel = 'flutter/assets';
  final messenger = TestDefaultBinaryMessengerBinding
      .instance.defaultBinaryMessenger;

  ByteData stringData(String value) {
    final bytes = Uint8List.fromList(utf8.encode(value));
    return ByteData.view(bytes.buffer);
  }

  group('MockYummyService', () {
    tearDown(() async {
      messenger.setMockMessageHandler(assetsChannel, null);
    });

    test('parses valid JSON assets', () async {
      messenger.setMockMessageHandler(assetsChannel, (message) async {
        if (message == null) return null;
        final key = utf8.decode(
          message.buffer.asUint8List(
            message.offsetInBytes,
            message.lengthInBytes,
          ),
        );

        if (key == 'assets/data/restaurants.json') {
          return stringData(
            '[{"id":"1","name":"Toyota Corolla","address":"Astana",'
            '"attributes":"Economy","imageUrl":"u","imageCredits":"c",'
            '"distance":1.2,"rating":4.6,"vehicleClass":"Economy",'
            '"hourlyRate":12,"items":[{"name":"Addon","description":"desc",'
            '"price":5,"imageUrl":"i"}]}]',
          );
        }
        if (key == 'assets/data/categories.json') {
          return stringData(
            '[{"name":"Economy","numberOfRestaurants":1,"imageUrl":"img"}]',
          );
        }
        if (key == 'assets/data/posts.json') {
          return stringData(
            '[{"id":"p1","profileImageUrl":"pic","comment":"hello",'
            '"timestamp":"10"}]',
          );
        }
        return null;
      });

      final service = MockYummyService();
      final data = await service.getExploreData();

      expect(data.restaurants.length, greaterThanOrEqualTo(1));
      expect(data.categories.length, 4);
      expect(data.friendPosts.length, 1);
      expect(
        data.restaurants.any(
          (restaurant) => restaurant.name == 'Toyota Corolla',
        ),
        isTrue,
      );
    });

    test('returns empty data when parsing fails', () async {
      messenger.setMockMessageHandler(assetsChannel, (message) async {
        if (message == null) return null;
        final key = utf8.decode(
          message.buffer.asUint8List(
            message.offsetInBytes,
            message.lengthInBytes,
          ),
        );
        if (key == 'assets/data/restaurants.json') {
          return stringData('not-json');
        }
        if (key == 'assets/data/categories.json') {
          return stringData('[]');
        }
        if (key == 'assets/data/posts.json') {
          return stringData('[]');
        }
        return null;
      });

      final service = MockYummyService();
      final data = await service.getExploreData();

      expect(data.restaurants, isEmpty);
      expect(data.categories, isEmpty);
      expect(data.friendPosts, isEmpty);
    });
  });
}
