import 'package:flutter/material.dart';
import 'package:flutter_app/core/di/injection_container.dart';
import 'package:flutter_app/core/local_storage/base_local_storage.dart';
import 'package:flutter_app/core/router/route_paths.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/theme_toggle_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/widgets/sign_in_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final name = authState is AuthSuccess ? authState.user : 'there';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [ThemeToggleButton(), SizedBox(width: 8)],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),

              
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Account Information"),
                onTap: () {
                  // context.go(RoutePaths.accountInfo);
                },
              ),

              
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("Language"),
                onTap: () {
                  // context.go(RoutePaths.language);
                },
              ),

              
              ListTile(
                leading: const Icon(Icons.accessibility_new),
                title: const Text("Accessibility Settings"),
                onTap: () {
                  // context.go(RoutePaths.accessibility);
                },
              ),

              
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text("Payment Methods"),
                onTap: () {
                  // context.go(RoutePaths.paymentMethods);
                },
              ),

              
              ListTile(
                leading: const Icon(Icons.location_on),
                title: const Text("Delivery Location"),
                onTap: () {
                  // context.go(RoutePaths.deliveryLocation);
                },
              ),

             
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text("About Us"),
                onTap: () {
                  // context.go(RoutePaths.aboutUs);
                },
              ),

              
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text("Privacy Policy"),
                onTap: () {
                  // context.go(RoutePaths.privacyPolicy);
                },
              ),

              const SizedBox(height: 20),

              
              TextButton(
                onPressed: () async {
                  await getIt<BaseLocalStorage>().clear();
                },
                child: const Text(
                  "Delete Cache",
                  style: TextStyle(color: Colors.red),
                  
                ),
              ),

              const Spacer(),

              
              SizedBox(
                width: double.infinity,
                child: SignInButton(
                  label: 'Log Out',
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                   context.go(RoutePaths.login);
                  },
                ),
              ),

              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }
}
