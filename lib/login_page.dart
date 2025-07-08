import 'package:flutter/material.dart';
import 'db_helper.dart'; // Make sure db_helper.dart is created

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _submit() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Input Error'),
          content: Text('Username and password can not be empty'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
      return;
    }

    // 🔽 यूज़र को डेटाबेस में सेव करें
    await DBHelper.insertUser(username, password);

    // ✅ Success message
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('User Saved'),
        content: Text('Username and Password saved successfully'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          )
        ],
      ),
    );

    // TextFields साफ करें
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  void initState() {
    super.initState();
    DBHelper.database; // DB initialize करना
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Registration',
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
