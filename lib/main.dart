import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/app_dependencies.dart';

void main() {
  final dependencies = AppDependencies.create();
  runApp(MyApp(dependencies: dependencies));
}
