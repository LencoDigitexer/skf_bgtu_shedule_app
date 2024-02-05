import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/group_selection_screen.dart';
import 'pages/home_screen.dart';
import 'pages/shedule_page.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? group_select = prefs.getString('group_select');

  runApp(MyApp(group_select: group_select));
}

final theme = AppTheme();

class MyApp extends StatelessWidget {
  final String? group_select;

  MyApp({this.group_select});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Расписание СКФ БГТУ',
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: ThemeMode.system,
      home: group_select != null
          ? HomeScreen(group_select: group_select!)
          : ScheduleTable(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _loginController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await saveCredentials(); /*
                Navigator.pushReplacement(
                  context,
                  
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                          login: _loginController.text,
                          password: _passwordController.text)),
                );*/
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', _loginController.text);
    prefs.setString('password', _passwordController.text);
  }
}
