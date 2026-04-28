enum QueryErrorType { configuration, network, server, parsing, unknown }

class QueryError {
  const QueryError({
    required this.type,
    required this.message,
    this.statusCode,
  });

  final QueryErrorType type;
  final String message;
  final int? statusCode;
}

class QueryResult<T> {
  const QueryResult._({
    required this.data,
    required this.error,
  });

  const QueryResult.success(T value)
      : this._(
          data: value,
          error: null,
        );

  const QueryResult.failure(QueryError err)
      : this._(
          data: null,
          error: err,
        );

  final T? data;
  final QueryError? error;

  bool get isSuccess => data != null && error == null;
  bool get isFailure => error != null;
}
