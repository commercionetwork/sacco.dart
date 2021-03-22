import 'package:equatable/equatable.dart';

/// [StdMsg] represents a standard message that can be included inside
/// a transaction.
class StdMsg extends Equatable {
  /// String representing the type of the message.
  final String type;

  /// Map containing the real value of the message.
  final Map<String, dynamic> value;

  /// Public constructor.
  const StdMsg({required this.type, required this.value});

  /// Converts this instance of [StdMsg] into a map that can be later used
  /// to serialize it as a JSON object.
  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
      };

  @override
  List<Object?> get props => [type, value];
}
