class DefaultFarmerAddress {
  final String address1;
  final String address2;
  final String name;
  final String landmark;
  final int contactNumber;
  final bool isDefault;

  DefaultFarmerAddress({
    required this.address1,
    required this.address2,
    required this.name,
    required this.landmark,
    required this.contactNumber,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'address1': address1,
      'address2': address2,
      'name': name,
      'landmark': landmark,
      'contactNumber': contactNumber,
      'isDefault': isDefault,
    };
  }

  factory DefaultFarmerAddress.fromJson(Map<String, dynamic> json) {
    return DefaultFarmerAddress(
      address1: json['address1'] ?? '',
      address2: json['address2'] ?? '',
      name: json['name'] ?? '',
      landmark: json['landmark'] ?? '',
      contactNumber: json['contactNumber'] ?? 0,
      isDefault: json['isDefault'] ?? false,
    );
  }
}
