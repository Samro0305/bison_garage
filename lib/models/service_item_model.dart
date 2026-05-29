class ServiceItemModel {
  final String serviceName;
  final double amount;

  const ServiceItemModel({
    required this.serviceName,
    required this.amount,
  });

  ServiceItemModel copyWith({
    String? serviceName,
    double? amount,
  }) {
    return ServiceItemModel(
      serviceName: serviceName ?? this.serviceName,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceName': serviceName,
      'amount': amount,
    };
  }

  factory ServiceItemModel.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return ServiceItemModel(
      serviceName: map['serviceName'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
    );
  }
}