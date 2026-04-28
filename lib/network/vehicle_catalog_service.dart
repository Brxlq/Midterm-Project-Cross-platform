import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'query_result.dart';
import 'vehicle_catalog_model.dart';

class VehicleCatalogService {
  VehicleCatalogService({
    http.Client? client,
    this.baseUrl = 'vpic.nhtsa.dot.gov',
    Duration? timeout,
  })  : _client = client ?? http.Client(),
        _timeout = timeout ?? const Duration(seconds: 8);

  final http.Client _client;
  final String baseUrl;
  final Duration _timeout;

  Future<QueryResult<VehicleCatalogResponse>> getMakes() async {
    final uri = Uri.https(baseUrl, '/api/vehicles/GetAllMakes', {
      'format': 'json',
    });

    try {
      final response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return QueryResult.failure(
          QueryError(
            type: QueryErrorType.server,
            message: 'Vehicle API request failed (${response.statusCode}).',
            statusCode: response.statusCode,
          ),
        );
      }

      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) {
        return QueryResult.failure(
          const QueryError(
            type: QueryErrorType.parsing,
            message: 'Unexpected vehicle catalog response format.',
          ),
        );
      }

      return QueryResult.success(VehicleCatalogResponse.fromJson(decoded));
    } on TimeoutException {
      return QueryResult.failure(
        const QueryError(
          type: QueryErrorType.network,
          message: 'Vehicle catalog request timed out.',
        ),
      );
    } on SocketException {
      return QueryResult.failure(
        const QueryError(
          type: QueryErrorType.network,
          message: 'No internet connection.',
        ),
      );
    } on FormatException {
      return QueryResult.failure(
        const QueryError(
          type: QueryErrorType.parsing,
          message: 'Unable to parse vehicle catalog response.',
        ),
      );
    } catch (_) {
      return QueryResult.failure(
        const QueryError(
          type: QueryErrorType.unknown,
          message: 'Unexpected error while loading vehicle catalog.',
        ),
      );
    }
  }
}
