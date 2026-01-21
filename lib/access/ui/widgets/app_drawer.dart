import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_alarm/bloc/auth/auth_bloc.dart';
import 'package:simple_alarm/bloc/auth/auth_event.dart';
import 'package:simple_alarm/bloc/auth/auth_state.dart';
import 'package:simple_alarm/access/ui/pages/auth/login_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Authenticated) {
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: const Text('Welcome'), // Placeholder
                  accountEmail: const Text('You are logged in'), // Placeholder
                  currentAccountPicture: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Logout'),
                  onTap: () {
                    // Close the drawer first
                    Navigator.pop(context);
                    // Dispatch the logout event
                    context.read<AuthBloc>().add(LoggedOut());
                  },
                ),
              ],
            );
          } else {
            // Unauthenticated or other states
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'Welcome',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.login),
                  title: const Text('Login / Register'),
                  onTap: () {
                    // Close the drawer first
                    Navigator.pop(context);
                    // Navigate to the login page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
