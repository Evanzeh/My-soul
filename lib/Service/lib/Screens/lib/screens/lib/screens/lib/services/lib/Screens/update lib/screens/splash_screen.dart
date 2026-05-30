import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'auth_phone.dart';
import 'home_screen.dart';
import 'profile_setup.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), checkAuth);
  }

  void checkAuth() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    if (auth.currentUser == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AuthPhoneScreen()));
      return;
    }

    final userData = await UserService().getCurrentUserData();
    if (userData == null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ProfileSetupScreen()));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, size: 80, color: Color(0xFFB71C1C)),
            SizedBox(height: 20),
            Text('My Soul', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 8),
            Text('For Kenyans Only', style: TextStyle(fontSize: 16, color: Colors.grey[400])),
            SizedBox(height: 40),
            CircularProgressIndicator(color: Color(0xFFB71C1C)),
          ],
        ),
      ),
    );
  }
}
