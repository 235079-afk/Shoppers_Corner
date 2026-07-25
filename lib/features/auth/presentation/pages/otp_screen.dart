import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/router/route_paths.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class OtpScreen extends StatelessWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

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
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthOtpVerified) {
                context.go(RoutePaths.home);
              }
            },
            builder: (context, state) {
              final isVerifying = state is AuthLoading;
              final errorMessage = state is AuthError ? state.message : null;

              return Column(
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
                    email,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 40),

                  Pinput(
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(),
                    onCompleted: (otp) =>
                        context.read<AuthCubit>().verifyOtp(email, otp),
                  ),

                  const SizedBox(height: 20),

                  if (errorMessage != null)
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  const SizedBox(height: 20),

                  if (isVerifying)
                    const CircularProgressIndicator(strokeWidth: 2),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
