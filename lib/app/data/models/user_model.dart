import 'package:flutter_music_clean_getx/app/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.createdBy,
    required super.updatedBy,
    super.createdAt,
    super.updatedAt,
    required super.email,
    required super.firstName,
    required super.lastName,
    super.imageProfile,
  });

  static DateTime? _tryParseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  String get fullName => '$firstName $lastName';

  static int _parseId(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _parseId(json['id']),
      createdBy: (json['created_by'] as String?) ?? '',
      updatedBy: (json['updated_by'] as String?) ?? '',
      createdAt: _tryParseDateTime(json['created_at']),
      updatedAt: _tryParseDateTime(json['updated_at']),
      email: (json['email'] as String?) ?? '',
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      imageProfile: json['image_profile'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'image_profile': imageProfile,
    };
  }
}