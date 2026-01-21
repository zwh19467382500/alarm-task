import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/access/ui/pages/auth/login_page.dart';
import 'package:simple_alarm/access/ui/pages/home_page.dart';
import 'package:simple_alarm/bloc/auth/auth_bloc.dart';
import 'package:simple_alarm/bloc/auth/auth_state.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomePage();
        }
        if (state is Unauthenticated) {
          return const LoginPage();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
