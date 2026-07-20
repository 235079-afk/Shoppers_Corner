import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel(super.name);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['name'] as String? ?? json['username'] as String? ?? 'there',
    );
  }
}
