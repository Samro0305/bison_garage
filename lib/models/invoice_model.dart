import 'service_item_model.dart';

class InvoiceModel {
  final String invoiceId;
  final String invoiceNumber;
  final String customerName;
  final String customerPhone;
  final String vehicleNumber;

  final List<ServiceItemModel> services;

  final double subtotal;
  final double gstAmount;
  final double grandTotal;

  final bool isGstApplied;

  final DateTime createdAt;

  const InvoiceModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.customerName,
    required this.customerPhone,
    required this.vehicleNumber,
    required this.services,
    required this.subtotal,
    required this.gstAmount,
    required this.grandTotal,
    required this.isGstApplied,
    required this.createdAt,
  });

  InvoiceModel copyWith({
    String? invoiceId,
    String? invoiceNumber,
    String? customerName,
    String? customerPhone,
    String? vehicleNumber,
    List<ServiceItemModel>? services,
    double? subtotal,
    double? gstAmount,
    double? grandTotal,
    bool? isGstApplied,
    DateTime? createdAt,
  }) {
    return InvoiceModel(
      invoiceId: invoiceId ?? this.invoiceId,
      invoiceNumber:   invoiceNumber ?? this.invoiceNumber,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      services: services ?? this.services,
      subtotal: subtotal ?? this.subtotal,
      gstAmount: gstAmount ?? this.gstAmount,
      grandTotal: grandTotal ?? this.grandTotal,
      isGstApplied: isGstApplied ?? this.isGstApplied,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invoiceId': invoiceId,
      'invoiceNumber': invoiceNumber,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'vehicleNumber': vehicleNumber,
      'services': services
          .map((service) => service.toMap())
          .toList(),
      'subtotal': subtotal,
      'gstAmount': gstAmount,
      'grandTotal': grandTotal,
      'isGstApplied': isGstApplied,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory InvoiceModel.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return InvoiceModel(
      invoiceId: map['invoiceId'] ?? '',
      invoiceNumber:
    map['invoiceNumber'] ??
    'INV-0000',
      customerName: map['customerName'] ?? '',
      customerPhone: map['customerPhone'] ?? '',
      vehicleNumber: map['vehicleNumber'] ?? '',
      services: (map['services'] as List<dynamic>? ?? [])
          .map(
            (item) => ServiceItemModel.fromMap(item),
          )
          .toList(),
      subtotal: (map['subtotal'] ?? 0).toDouble(),
      gstAmount: (map['gstAmount'] ?? 0).toDouble(),
      grandTotal: (map['grandTotal'] ?? 0).toDouble(),
      isGstApplied: map['isGstApplied'] ?? false,
      createdAt: DateTime.parse(
        map['createdAt'],
      ),
    );
  }
}