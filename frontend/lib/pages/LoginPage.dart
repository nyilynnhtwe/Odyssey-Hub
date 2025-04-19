import 'package:flutter/material.dart';
import 'package:frontend/pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final List<String> _scopes = const ['email'];

  late GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn = GoogleSignIn(
      scopes: _scopes,
      clientId:
          // Your client id
    );

    // Check for existing sign-in
    _googleSignIn.signInSilently().then((account) {
      if (account != null) {
        _handleAuthorizeScopes(account);
      }
    });

    // Listen for sign-in changes
    _googleSignIn.onCurrentUserChanged.listen((account) {
      if (account != null) {
        _handleAuthorizeScopes(account);
      }
      setState(() {
        _currentUser = account;
      });
    });
  }

  Future<void> _handleAuthorizeScopes(GoogleSignInAccount account) async {
    bool isAuthorized = await _googleSignIn.canAccessScopes(_scopes);
    if (!isAuthorized) {
      isAuthorized = await _googleSignIn.requestScopes(_scopes);
    }

    setState(() {
      _isAuthorized = isAuthorized;
    });

    if (isAuthorized) {
      // Navigate to home page or perform post-login actions
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print('Error signing in: $error');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to sign in with Google')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Odyssey Hub",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your journey starts here",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            if (_currentUser == null)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _handleGoogleSignIn,
                icon: Image.asset('assets/google_logo.png', height: 24),
                label: const Text(
                  'Login with Google',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            if (_currentUser != null)
              Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(_currentUser!.photoUrl ?? ''),
                  ),
                  const SizedBox(height: 10),
                  Text('Welcome, ${_currentUser!.displayName}'),
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
