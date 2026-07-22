import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
    );
  }
}
