import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/app/simple_app_wrapper.dart';

void main() {
  runApp(
    const ProviderScope(
      child: UCIGigaliApp(),
    ),
  );
}

class UCIGigaliApp extends StatelessWidget {
  const UCIGigaliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: AppTheme.themeData,
      debugShowCheckedModeBanner: false,
      home: const SimpleAppWrapper(),
    );
  }
}