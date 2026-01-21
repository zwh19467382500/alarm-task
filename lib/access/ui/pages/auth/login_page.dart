import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/access/ui/pages/home_page.dart';
import 'package:simple_alarm/bloc/auth/auth_bloc.dart';
import 'package:simple_alarm/bloc/auth/auth_event.dart';
import 'package:simple_alarm/bloc/auth/auth_state.dart';
import 'package:simple_alarm/service/settings_service.dart';
import 'package:simple_alarm/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_isLogin) {
        context.read<AuthBloc>().add(LoginRequested(
              username: _usernameController.text,
              password: _passwordController.text,
            ));
      } else {
        context.read<AuthBloc>().add(RegisterRequested(
              username: _usernameController.text,
              password: _passwordController.text,
            ));
      }
    }
  }

  void _skipLogin() {
    locator<SettingsService>().setSkippedLogin(true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
          // ADDED: Navigate to home on successful login/registration
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin ? 'Welcome Back' : 'Create Account',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder()),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Please enter a username' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                    obscureText: true,
                    validator: (value) => (value?.isEmpty ?? true) ? 'Please enter a password' : null,
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const CircularProgressIndicator();
                      }
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(_isLogin ? 'Login' : 'Register'),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: _toggleForm,
                    child: Text(_isLogin ? 'Need an account? Register' : 'Have an account? Login'),
                  ),
                  TextButton(
                    onPressed: _skipLogin,
                    child: const Text('Skip for now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}