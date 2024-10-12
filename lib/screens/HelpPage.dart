import 'package:flutter/material.dart';
 
class HelpPage extends StatelessWidget {
  static const String id = 'HelpPage';
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: ClipPath(
          clipper: RoundedAppBarClipper(),
          child: Container(
            height: 200,
            color: Colors.blue,
            child: AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
              title: Text(
                'Help',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Contact Us On Phone'),
            subtitle: Text('You can reach us through "01062438923"'),
          ),
          ListTile(
            title: Text('Contact Us On Email'),
            subtitle: Text('SnapMartSupportTeam@gmail.com'),
          ),
          // Add more list tiles for additional instructions
        ],
      ),
    );
  }
}
 
// Custom Clipper for Rounded AppBar Shape
class RoundedAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
 
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}