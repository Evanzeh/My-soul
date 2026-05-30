import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'auth_phone.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();
  
  // Dummy data for now. File 8 will replace with Firestore
  final List<Map<String, dynamic>> users = [
    {
      'name': 'Wanjiku, 24',
      'bio': 'Nairobi • Loves nyama choma',
      'image': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330',
    },
    {
      'name': 'Brian, 27', 
      'bio': 'Mombasa • Gym & beach',
      'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
    },
    {
      'name': 'Aisha, 22',
      'bio': 'Kisumu • Music lover',
      'image': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Soul', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).signOut();
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => AuthPhoneScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CardSwiper(
                controller: controller,
                cardsCount: users.length,
                onSwipe: (prevIndex, currIndex, direction) {
                  if (direction == CardSwiperDirection.right
