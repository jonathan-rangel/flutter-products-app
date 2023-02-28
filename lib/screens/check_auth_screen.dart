import 'package:flutter/material.dart';
import 'package:flutter_products/screens/screens.dart';
import 'package:flutter_products/services/services.dart';
import 'package:provider/provider.dart';

class CheckAuthScreen extends StatelessWidget {
  const CheckAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: authService.isAuthenticated(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('');
              } else if (snapshot.data == '') {
                Future.microtask(
                  () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const LoginScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  },
                );
              } else {
                Future.microtask(
                  () {
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomeScreen(),
                        transitionDuration: const Duration(seconds: 0),
                      ),
                    );
                  },
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
