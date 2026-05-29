class GarageSettingsModel {
  final String garageName;
  final String ownerName;
  final String phoneNumber;
  final String address;
  final String gstNumber;

  const GarageSettingsModel({
    required this.garageName,
    required this.ownerName,
    required this.phoneNumber,
    required this.address,
    required this.gstNumber,
  });

  factory GarageSettingsModel.empty() {
    return const GarageSettingsModel(
      garageName: '',
      ownerName: '',
      phoneNumber: '',
      address: '',
      gstNumber: '',
    );
  }

  GarageSettingsModel copyWith({
    String? garageName,
    String? ownerName,
    String? phoneNumber,
    String? address,
    String? gstNumber,
  }) {
    return GarageSettingsModel(
      garageName: garageName ?? this.garageName,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'garageName': garageName,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'gstNumber': gstNumber,
    };
  }

  factory GarageSettingsModel.fromMap(
    Map<dynamic, dynamic> map,
  ) {
    return GarageSettingsModel(
      garageName: map['garageName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      gstNumber: map['gstNumber'] ?? '',
    );
  }
}