class GarageSettingsModel {
  final String garageName;
  final String ownerName;
  final String phoneNumber;
  final String address;
  final String gstNumber;
  final String logoPath;
  final String password;
  final String signaturePath;

  const GarageSettingsModel({
    required this.garageName,
    required this.ownerName,
    required this.phoneNumber,
    required this.address,
    required this.gstNumber,
    required this.logoPath,
required this.password,
required this.signaturePath,
  });

  factory GarageSettingsModel.empty() {
  return const GarageSettingsModel(
    garageName: '',
    ownerName: '',
    phoneNumber: '',
    address: '',
    gstNumber: '',
    logoPath: '',
    password: 'bison1234',
    signaturePath: '',
  );
}

  GarageSettingsModel copyWith({
    String? garageName,
    String? ownerName,
    String? phoneNumber,
    String? address,
    String? gstNumber,
    String? logoPath,
    String? password,
    String? signaturePath,
    
  }) {
    return GarageSettingsModel(
      garageName: garageName ?? this.garageName,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      logoPath: logoPath ?? this.logoPath,
      password: password ?? this.password,
      signaturePath:
    signaturePath ?? this.signaturePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'garageName': garageName,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'address': address,
      'gstNumber': gstNumber,
      'logoPath': logoPath,
      'password': password,
      'signaturePath': signaturePath,
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
      logoPath: map['logoPath'] ?? '',
      password: map['password'] ?? 'bison1234',
      signaturePath:
    map['signaturePath'] ?? '',
    );
  }
}