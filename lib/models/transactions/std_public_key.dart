class StdPublicKey {
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
}
