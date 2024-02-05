import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'group_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  final String group_select;

  HomeScreen({required this.group_select});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Login: $group_select'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                clearCredentials();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GroupSelectionScreen()),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('group_select');
  }
}
