import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool _isVerifying = false;
  String? _statusMessage;

  Future<bool> verifyOtp(String email, String otp) async {
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

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    return response.statusCode == 200;
  }

  Future<void> _handleVerify(String otp) async {
    setState(() => _isVerifying = true);

    final success = await verifyOtp(widget.email, otp);

    if (!mounted) return;

    setState(() => _isVerifying = false);

    if (success) {
      context.go('/home');
    } else {
      setState(() {
        _statusMessage = "Invalid OTP. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 2),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "We sent a code to:",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 20,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 40),

              // ⭐ Centered Pinput
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(),
                onCompleted: (otp) => _handleVerify(otp),
              ),

              const SizedBox(height: 20),

              // ⭐ Centered inline error message
              if (_statusMessage != null)
                Text(
                  _statusMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(height: 20),

              if (_isVerifying)
                const CircularProgressIndicator(strokeWidth: 2),
            ],
          ),
        ),
      ),
    );
  }
}
