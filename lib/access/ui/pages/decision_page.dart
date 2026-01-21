import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/access/ui/pages/auth/login_page.dart';
import 'package:simple_alarm/access/ui/pages/home_page.dart';
import 'package:simple_alarm/bloc/auth/auth_bloc.dart';
import 'package:simple_alarm/bloc/auth/auth_state.dart';
import 'package:simple_alarm/service/settings_service.dart';
import 'package:simple_alarm/service_locator.dart';

class DecisionPage extends StatelessWidget {
  const DecisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      // The listener will be called for every state change
      listener: (context, state) {
        // We only care about the first "real" state after loading
        if (state is Authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (state is Unauthenticated) {
          final settingsService = locator<SettingsService>();
          if (settingsService.hasSkippedLogin()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        }
      },
      // The child is just the loading indicator
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}