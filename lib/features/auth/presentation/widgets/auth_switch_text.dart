import 'package:flutter/material.dart';

class AuthSwitchText extends StatelessWidget {
  final bool isLogin;
  final VoidCallback onPressed;

  const AuthSwitchText({
    super.key,
    required this.isLogin,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final question =
        isLogin ? "Don't have an account?" : 'Already have an account?';
    final actionText = isLogin ? 'Create an account' : 'Log in';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          question,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionText,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
