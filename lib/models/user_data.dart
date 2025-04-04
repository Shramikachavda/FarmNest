import 'package:uuid/uuid.dart';

class UserModelDb {
  String id;
  final String name;
  final String email;

  UserModelDb({
    String? id,
    required this.name,
    required this.email,
  }) : id = id ?? const Uuid().v4(); // Generate UUID if not provided

  /// 🔁 Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  /// 🔄 Convert Firestore Map to UserModel
  factory UserModelDb.fromMap(Map<String, dynamic> map) {
    return UserModelDb(
      id: map['id'],
      name: map['name'],
      email: map['email'],
    );
  }
}
