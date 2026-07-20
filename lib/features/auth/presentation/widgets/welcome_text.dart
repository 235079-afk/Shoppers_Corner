import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  final String text;

  const WelcomeText({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      text,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}
