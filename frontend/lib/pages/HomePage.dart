import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userPhoto;
  final String userName;
  final String userEmail;

  const HomePage({
    super.key,
    required this.userPhoto,
    required this.userName,
    required this.userEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome $userName')),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(userPhoto)),
            Text('Email: $userEmail'),
            // Add other user info here
          ],
        ),
      ),
    );
  }
}
