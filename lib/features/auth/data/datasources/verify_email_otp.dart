import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> sendOtp(String email) async {
  final url = Uri.parse(
    "https://accessories-eshop.runasp.net/api/auth/send-email-verification",
  );

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"email": email}),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    print("Send OTP failed: ${response.body}");
    return false;
  }
}
