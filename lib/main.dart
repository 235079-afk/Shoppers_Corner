import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/injection_container.dart';
import 'package:email_otp/email_otp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  EmailOTP.config(
    appName: 'Shopping Corner',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v1,
  );
  initDependencies();
  runApp(const MyApp());
}
