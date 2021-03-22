import 'package:equatable/equatable.dart';

class StdPublicKey extends Equatable {
  final String type;
  final String value;

  const StdPublicKey({
    required this.type,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
      };

  @override
  List<Object?> get props => [type, value];
}
