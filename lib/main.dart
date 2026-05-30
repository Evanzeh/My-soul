import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/splash_screen.dart';
import 'screens/auth_phone.dart';
import 'services/auth_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MySoulApp());
}

class MySoulApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'My Soul',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFFB71C1C), // Dark red
          scaffoldBackgroundColor: Color(0xFF121212),
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFB71C1C),
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFB71C1C),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
