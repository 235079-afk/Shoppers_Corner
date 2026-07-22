class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
  };
}
class LoginResponse {
  final String token;
  final String userId;

  LoginResponse({required this.token, required this.userId});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"],
      userId: json["userId"],
    );
  }
}
