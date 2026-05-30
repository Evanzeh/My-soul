import 'package:flutter/material.dart';
import '../services/user_service.dart';
import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';
  String _county = 'Nairobi';
  bool _loading = false;

  final List<String> counties = [
    'Nairobi','Mombasa','Kisumu','Nakuru','Kiambu','Machakos','Kajiado','Uasin Gishu',
    'Kakamega','Bungoma','Kilifi','Meru','Nyeri','Laikipia'
  ];

  void _saveProfile() async {
    if (_nameController.text.isEmpty || _ageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jaza jina na miaka'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    await UserService().createUserProfile(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text),
      gender: _gender,
      county: _county,
    );
    setState(() => _loading = false);

    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Setup Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Karibu My Soul', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Jaza details zako to start swiping', style: TextStyle(color: Colors.grey[400])),
            SizedBox(height: 32),
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Jina',
                filled: true, fillColor: Color(0xFF1E1E1E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white
