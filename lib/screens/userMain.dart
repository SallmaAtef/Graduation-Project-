import 'package:flutter/material.dart';
import 'package:snapmart/screens/chats_screen.dart';
import 'package:snapmart/screens/favorite_screen.dart';
import 'package:snapmart/screens/takephoto.dart';
import 'package:snapmart/screens/userhome.dart';
import 'package:snapmart/screens/vendorHome.dart';
import 'package:snapmart/screens/vendorProfile.dart';
import 'package:snapmart/widgets/constant.dart';

class UserMain extends StatefulWidget {
  const UserMain({super.key});

  @override
  State<UserMain> createState() => _userMain();
}

class _userMain extends State<UserMain> {
  int currentTab = 0;
  List<Widget> screens = [
    UserHome(),
    FavoritePage(),
    ChatsScreen(),
    UploadImage(),
    VendorProfile()
    // BrandProfile(name: name, category: category, followers: followers, description: description, coverImage: coverImage, profileImage: profileImage),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: currentTab,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: Colors.grey.shade500,
        onTap: (index){
          setState(() {
            currentTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home',),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'Favorites',),
          BottomNavigationBarItem(icon: Icon(Icons.message),label: 'Chats',),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt_rounded),label: 'Search',),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile',)
        ],

      ),
      body: screens[currentTab],
    );
  }

}
