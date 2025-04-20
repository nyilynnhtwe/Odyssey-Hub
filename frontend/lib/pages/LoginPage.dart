import 'package:flutter/material.dart';
import 'package:frontend/pages/HomePage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSignIn();
  }

  Future<void> _checkExistingSignIn() async {
    if (await _googleSignIn.isSignedIn()) {
      _navigateToHome(await _googleSignIn.signInSilently());
    }
  }

  Future<void> _handleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      _navigateToHome(googleUser);
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToHome(GoogleSignInAccount? user) {
    if (user == null) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => HomePage(
              userPhoto: user.photoUrl ?? '',
              userName: user.displayName ?? 'Anonymous',
              userEmail: user.email ?? '',
            ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
            const _AppTitle(),
            const SizedBox(height: 40),
            _isLoading
                ? const CircularProgressIndicator()
                : _GoogleSignInButton(onPressed: _handleSignIn),
          ],
        ),
      ),
    );
  }
}

class _AppTitle extends StatelessWidget {
  const _AppTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Odyssey Hub",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Your journey starts here",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _GoogleSignInButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: onPressed,
      icon: Image.asset('assets/google_logo.png', height: 24),
      label: const Text(
        'Login with Google',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
