import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '/pages/Register_page.dart';
import '/pages/Home_page.dart';
import '/providers/auth_provider.dart';
import '/providers/services_provider.dart';
import '/services/auth_service.dart';
import '/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),
        ChangeNotifierProvider<ServicesProvider>(
          create: (_) => ServicesProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Moseef',
        theme: AppTheme.lightTheme,
        routes: {'/home': (context) => const HomePagem()},
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              if (authProvider.isAuthenticated) {
                return const HomePagem();
              } else {
                return const RegisterPage();
              }
            },
          ),
        ),
      ),
    );
  }
}
