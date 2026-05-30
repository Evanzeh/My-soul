import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'auth_phone.dart';
import 'matches_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();
  final UserService _userService = UserService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      _buildSwipeScreen(),
      MatchesScreen(),
    ];

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Color(0xFF1E1E1E),
        selectedItemColor: Color(0xFFB71C1C),
        unselectedItemColor: Colors.grey[600],
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Matches'),
        ],
      ),
    );
  }

  Widget _buildSwipeScreen() {
    return Scaffold(
      appBar: AppBar(
        title
