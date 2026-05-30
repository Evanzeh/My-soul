import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'auth_phone.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CardSwiperController controller = CardSwiperController();
  final UserService _userService = UserService();

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
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _userService.getPotentialMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Color(0xFFB71C1C)));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('Hakuna watu karibu yako sasa',
                  style: TextStyle(color: Colors.grey[400], fontSize: 18)),
              );
            }

            final users = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: users.length,
                    onSwipe: (prevIndex, currIndex, direction) async {
                      if (direction == CardSwiperDirection.right) {
                        await _userService.likeUser(users[prevIndex]['uid']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Liked ${users[prevIndex]['name']}'),
                          duration: Duration(seconds: 1)),
                        );
                      }
                      return true;
                    },
                    cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                      final user = users[index];
                      final photo = user['photos']!= null && user['photos'].isNotEmpty
                         ? user['photos'][0]
                          : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb';

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(photo),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black87],
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${user['name']}, ${user['age']}',
                                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text('${user['county']} • ${user['gender']}',
                                  style: TextStyle(color: Colors.white70, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        heroTag: 'pass',
                        backgroundColor: Colors.white,
                        onPressed: () => controller.swipe(CardSwiperDirection.left),
                        child: Icon(Icons.close, color: Colors.red, size: 32),
                      ),
                      FloatingActionButton(
                        heroTag: 'like',
                        backgroundColor: Color(0xFFB71C1C),
                        onPressed: () => controller.swipe(CardSwiperDirection.right),
                        child: Icon(Icons.favorite, color: Colors.white, size: 32),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
