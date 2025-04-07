class DefaultFarmerAddress {
  final String address1;
  final String address2;
  final String address3;
  final String? landmark;
  final int contactNumber;

  DefaultFarmerAddress({
    required this.address1,
    required this.address2,
    required this.address3,
    this.landmark,
    required this.contactNumber,
  });

  factory DefaultFarmerAddress.fromJson(Map<String, dynamic> json) {
    return DefaultFarmerAddress(
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      address3: json['address3'] ?? '',
      landmark: json['landmark'],
      contactNumber: json['contactNumber'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'landmark': landmark,
      'contactNumber': contactNumber,
    };
  }

  DefaultFarmerAddress copyWith({
    String? address1,
    String? address2,
    String? address3,
    String? landmark,
    int? contactNumber,
  }) {
    return DefaultFarmerAddress(
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      address3: address3 ?? this.address3,
      landmark: landmark ?? this.landmark,
      contactNumber: contactNumber ?? this.contactNumber,
    );
  }

}
