import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'theme_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: first(),
        );
      },
    );
  }

  Widget first()
  {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null)
    {
      return login();
    } else {
      return HomePage();
    }
  }
}