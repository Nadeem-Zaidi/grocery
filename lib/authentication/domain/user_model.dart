class AuthUserModel {
  final String id;
  final String phoneNumber;

  const AuthUserModel({
    required this.id,
    required this.phoneNumber,
  });

  // Factory constructor for creating an "empty" instance
  factory AuthUserModel.empty() {
    return const AuthUserModel(
      id: '',
      phoneNumber: '',
    );
  }

  // Override toString for better debugging
  @override
  String toString() {
    return 'AuthUserModel(id: $id, phoneNumber: $phoneNumber)';
  }

  // Override equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUserModel &&
        other.id == id &&
        other.phoneNumber == phoneNumber;
  }

  @override
  int get hashCode => id.hashCode ^ phoneNumber.hashCode;

  // CopyWith method for immutability
  AuthUserModel copyWith({
    String? id,
    String? phoneNumber,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
