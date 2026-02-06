class User {
  const User({
    required this.id,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.imageProfile,
  });

  final int id;
  final String createdBy;
  final String updatedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String email;
  final String firstName;
  final String lastName;
  final String? imageProfile;
}
