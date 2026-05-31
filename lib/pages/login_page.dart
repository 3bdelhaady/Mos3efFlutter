import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_page.dart';
import 'Home_page.dart';
import '/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(AuthProvider authProvider) {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى إدخال البريد الإلكتروني وكلمة المرور"),
        ),
      );
      return;
    }

    authProvider.login(email, password).then((_) {
      if (authProvider.isAuthenticated) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("تم تسجيل الدخول بنجاح")));

        // Navigate to home page after successful login
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (authProvider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage)));
      }
    });
  }

  void _handleGoogleLogin(AuthProvider authProvider) {
    authProvider.loginWithGoogle().then((_) {
      if (authProvider.isAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("تم تسجيل الدخول عبر Google بنجاح")),
        );

        // Navigate to home page after successful Google login
        Navigator.of(context).pushReplacementNamed('/home');
      } else if (authProvider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authProvider.errorMessage)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Text(
                                  "تسجيل",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              child: const Text(
                                "دخول",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Image.asset('Image/Logo.png', width: 90, height: 90),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Image.asset(
                            'Image/Doctors_bro_1.png',
                            width: 250,
                            height: 250,
                          ),
                          const SizedBox(height: 20),
                          Image.asset(
                            'Image/Container.png',
                            width: double.infinity,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 25),
                          TextField(
                            controller: _emailController,
                            enabled: !authProvider.isLoading,
                            decoration: InputDecoration(
                              labelText: "البريد الإلكتروني",
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: _passwordController,
                            enabled: !authProvider.isLoading,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "كلمة المرور",
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: authProvider.isLoading
                                ? null
                                : () => _handleLogin(authProvider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: authProvider.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        "دخول",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  'أو',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey[400],
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: authProvider.isLoading
                                ? null
                                : () => _handleGoogleLogin(authProvider),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'Image/Logo.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'دخول عبر Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (authProvider.errorMessage.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                authProvider.errorMessage,
                                style: TextStyle(
                                  color: Colors.red[800],
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
