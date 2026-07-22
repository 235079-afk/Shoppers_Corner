import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> verifyEmailOtp(String email, String otp) async {
  final url = Uri.parse(
    "https://accessories-eshop.runasp.net/api/auth/verify-email",
  );

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "email": email,
      "otp": otp,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print("Verify OTP failed: ${response.body}");
    return false;
  }
}
