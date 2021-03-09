import 'package:equatable/equatable.dart';

/// Represents the result that is returned when broadcasting a transaction.
class TransactionResult extends Equatable {
  /// String representing the hash of the transaction.
  /// Note that this hash is always present, even if the transaction was
  /// not sent successfully.
  final String hash;

  /// Tells if the transaction was sent successfully or not.
  final bool success;

  /// Tells which error has verified if the sending was not successful.
  /// Please note that this field is going to be:
  /// - `null` if [success] is `true`.
  /// - a valid [TransactionError] if [success] is `false`
  final TransactionError? error;

  const TransactionResult({
    required this.hash,
    required this.success,
    this.error,
  }) : assert(success || error != null);

  @override
  List<Object?> get props => [hash, success, error];

  factory TransactionResult.fromJson(Map<String, dynamic> json) =>
      TransactionResult(
        hash: json['hash'] as String,
        success: json['success'] as bool,
        error: json['error'] == null
            ? null
            : TransactionError.fromJson(json['error']),
      );

  Map<String, dynamic> toJson() => {
        'hash': hash,
        'success': success,
        'error': error?.toJson(),
      };
}

/// Contains the data related to an error that has occurred when
/// broadcasting the transaction.
class TransactionError extends Equatable {
  final int errorCode;
  final String errorMessage;

  const TransactionError({
    required this.errorCode,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [errorCode, errorMessage];

  factory TransactionError.fromJson(Map<String, dynamic> json) =>
      TransactionError(
        errorCode: json['errorCode'] as int,
        errorMessage: json['errorMessage'] as String,
      );

  Map<String, dynamic> toJson() => {
        'errorCode': errorCode,
        'errorMessage': errorMessage,
      };
}
