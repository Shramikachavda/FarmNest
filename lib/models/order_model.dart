import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'product.dart';
import 'post_sign_up/default_farmer_address.dart';

class Order {
  String id;
  final Product product;
  final double total;
  final DateTime? timestamp;
  final String status;
  final DefaultFarmerAddress? address; // Add address field

  Order({
    String? id,
    required this.product,
    required this.total,
    this.timestamp,
    required this.status,
    this.address,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return {
      'orderId': id,
      'product': product.toMap(), // Serialize properly

    'total': total,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
      'status': status,
      'address': address?.toJson(), // Serialize address
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['orderId'] ?? const Uuid().v4(),
      product:Product.fromJson(json['product'] as Map<String, dynamic>),
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
      status: json['status'] ?? 'Pending',
      address: json['address'] != null
          ? DefaultFarmerAddress.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }
}