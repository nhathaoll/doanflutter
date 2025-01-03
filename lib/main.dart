import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/NotificationHelper.dart';
import 'AppNavigation.dart';
import 'screens/loginScreen.dart';
import 'databasehelper/SessionManager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationHelper.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _checkLoginStatus() async {
    return await SessionManager().isLoggedIn;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.data == true) {
              return AppNavigation();
            } else {
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}
