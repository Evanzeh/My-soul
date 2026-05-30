import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthPhoneScreen extends StatefulWidget {
  @override
  _AuthPhoneScreenState createState() => _AuthPhoneScreenState();
}

class _AuthPhoneScreenState extends State<AuthPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '+254');
  final TextEditingController _otpController = TextEditingController();
  String? _verificationId;
  bool _otpSent = false;
  bool _loading = false;

  void _sendOTP() async {
    setState(() => _loading = true);
    final auth = Provider.of<AuthService>(context, listen: false);

    await auth.sendOTP(
      phoneNumber: _phoneController.text.trim(),
      onCodeSent: (verificationId) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
          _loading = false;
        });
      },
      onError: (error) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      },
    );
  }

  void _verifyOTP() async {
    if (_verificationId == null) return;
    setState(() => _loading = true);

    final auth = Provider.of<AuthService>(context, listen: false);
    final user = await auth.verifyOTP(
      verificationId: _verificationId!,
      smsCode: _otpController.text.trim(),
    );

    setState(() => _loading = false);
    if (user!= null) {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text('My Soul',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFB71C1C)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text('For Kenyans Only',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 60),
              if (!_otpSent)...[
                Text('Enter your Safaricom/Airtel number', style: TextStyle(fontSize: 16)),
                SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Color(0xFFB71C1C)),
                    filled: true,
                    fillColor: Color(0xFF1E1E1E),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loading? null : _sendOTP,
                  child: _loading
                   ? CircularProgressIndicator(color: Colors.white)
                    : Text('Send OTP', style: TextStyle(fontSize: 16)),
                ),
              ] else...[
                Text('Enter 6-digit OTP sent to ${_phoneController.text}', style: TextStyle(fontSize:
