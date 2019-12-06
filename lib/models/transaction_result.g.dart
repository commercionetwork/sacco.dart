// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResult _$TransactionResultFromJson(Map<String, dynamic> json) {
  return TransactionResult(
    hash: json['hash'] as String,
    success: json['success'] as bool,
    error: json['error'] == null
        ? null
        : TransactionError.fromJson(json['error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$TransactionResultToJson(TransactionResult instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'success': instance.success,
      'error': instance.error?.toJson(),
    };

TransactionError _$TransactionErrorFromJson(Map<String, dynamic> json) {
  return TransactionError(
    errorCode: json['errorCode'] as int,
    errorMessage: json['errorMessage'] as String,
  );
}

Map<String, dynamic> _$TransactionErrorToJson(TransactionError instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMessage': instance.errorMessage,
    };
