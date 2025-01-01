import 'package:flutter/material.dart';

import '../databasehelper/SessionManager.dart';
import 'loginScreen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = SessionManager().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              SessionManager().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome, ${user?.name}!'),
      ),
    );
  }
}
