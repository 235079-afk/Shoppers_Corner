import 'package:flutter/material.dart';
import 'package:flutter_app/core/constants/local_keys.dart';
import 'package:flutter_app/core/di/injection_container.dart';
import 'package:flutter_app/core/local_storage/base_local_storage.dart';

import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen ({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
final BaseLocalStorage localStorage = getIt<BaseLocalStorage>();

  Future<void> _checkFirstOpen() async {
  //coment this line:
  final bool hasOpened = await localStorage.getBool(LocalKeys.isOpen) ?? false;

  await Future.delayed(const Duration(seconds: 2));

  if (!mounted) return;

//comment from here
  if (hasOpened) {
    context.go('/home');
  } else {
    context.go('/onboarding');
  //to here
  }
}

  @override
  void initState() {
    super.initState();
    _checkFirstOpen();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/icons8-bag-64.png"),
            const SizedBox(height: 12),
            const Text(
              "Gateway to Luxury",
              style: TextStyle(
                fontSize: 20
              ),),
          ],
        ),
      ),
    );
  }
}
