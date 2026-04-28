import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:yummy/network/query_result.dart';
import 'package:yummy/network/spoonacular_model.dart';
import 'package:yummy/network/spoonacular_service.dart';

void main() {
  group('SpoonacularService', () {
    test('returns parsed recipes for successful response', () async {
      final client = MockClient((request) async {
        return http.Response(
          '{"results":[{"id":1,"title":"Pasta","image":"https://a.com/p.jpg"}],"totalResults":1}',
          200,
        );
      });

      final service = SpoonacularService(client: client, apiKey: 'demo-key');
      final result = await service.searchRecipes(
        const RecipeSearchRequest(query: 'pasta'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.data?.results.length, 1);
      expect(result.data?.results.first.title, 'Pasta');
      expect(result.data?.totalResults, 1);
    });

    test('maps server errors to QueryErrorType.server', () async {
      final client = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      final service = SpoonacularService(client: client, apiKey: 'bad-key');
      final result = await service.searchRecipes(
        const RecipeSearchRequest(query: 'pasta'),
      );

      expect(result.isFailure, isTrue);
      expect(result.error?.type, QueryErrorType.server);
      expect(result.error?.statusCode, 401);
    });

    test('returns parsing error for malformed JSON', () async {
      final client = MockClient((request) async {
        return http.Response('not-json', 200);
      });

      final service = SpoonacularService(client: client, apiKey: 'demo-key');
      final result = await service.searchRecipes(
        const RecipeSearchRequest(query: 'pasta'),
      );

      expect(result.isFailure, isTrue);
      expect(result.error?.type, QueryErrorType.parsing);
    });

    test('maps timeout to network error', () async {
      final client = MockClient((request) async {
        await Future<void>.delayed(const Duration(milliseconds: 50));
        return http.Response('{"results":[],"totalResults":0}', 200);
      });

      final service = SpoonacularService(
        client: client,
        apiKey: 'demo-key',
        timeout: const Duration(milliseconds: 5),
      );
      final result = await service.searchRecipes(
        const RecipeSearchRequest(query: 'pasta'),
      );

      expect(result.isFailure, isTrue);
      expect(result.error?.type, QueryErrorType.network);
    });
  });
}
