// Core network result wrapper for predictable error handling
//
// Usage:
// Result<Music> getMusic() { ... }
//
// final result = await getMusic();
// result.when(
//   success: (data) => print(data),
//   failure: (error, stackTrace) => print(error),
// );

sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;
  factory Result.failure(Exception error, [StackTrace? stackTrace]) =
      Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Exception error, StackTrace? stackTrace) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Failure<T>) {
      final fail = this as Failure<T>;
      return failure(fail.error, fail.stackTrace);
    }
    throw StateError('Unknown result type: $runtimeType');
  }
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error, [this.stackTrace]);
  final Exception error;
  final StackTrace? stackTrace;
}
