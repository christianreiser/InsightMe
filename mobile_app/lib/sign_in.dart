import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'authentication.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final Authentication _auth = Authentication();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showEmailPasswordOverlay = false;

  Widget _buildEmailPasswordOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            constraints: BoxConstraints(minWidth: 500),
            child: Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        final userCredential =
                        await _auth.signInWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (userCredential.user != null) {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: Text('Sign In with Email'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showEmailPasswordOverlay = false;
                        });
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showEmailPasswordOverlay = true;
                      });
                    },
                    child: Text('Sign In with Email'),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final userCredential = await _auth.signInWithGoogle();
                      if (userCredential.user != null) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text('Sign In with Google'),
                  ),
                ),
              ],
            ),
          ),
          if (_showEmailPasswordOverlay) _buildEmailPasswordOverlay(),
        ],
      ),
    );
  }
}
