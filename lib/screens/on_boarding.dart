import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/services.dart';

import '../widgets/constant.dart';
import 'enter.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({Key? key}) : super(key: key);
  static String id = 'onBordingscreen';

  @override
  _OnBordingScreenState createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  double scrollerPosition = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (val) {
              setState(() {
                scrollerPosition = val.toDouble();
              });
            },
            children: [
              OnBoardPage(
                bordcolumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'welcome\nto SNAPMART',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                          fontSize: 32),
                    ),
                    Image.asset('images/icons/browsing.png'),
                  ],
                ),
              ),
              OnBoardPage(
                bordcolumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '+10 Million products\n+100 categories',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(187, 76, 175, 79),
                          fontSize: 28),
                    ),
                    SizedBox(
                        height: 350,
                        width: 350,
                        child: Image.asset('images/icons/online-shop.png')),
                  ],
                ),
              ),
              OnBoardPage(
                bordcolumn: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Search & Filter',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                          fontSize: 30),
                    ),
                    SizedBox(
                        height: 350,
                        width: 350,
                        child: Image.asset('images/icons/search.png')),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DotsIndicator(
                  dotsCount: 3,
                  position: scrollerPosition.toInt(),
                  decorator: DotsDecorator(activeColor: kPrimaryLightColor),
                ),
                TextButton(
                  child: Text(
                    'SKIP TO THE APP >',
                    style: TextStyle(fontSize: 20, color: kPrimaryLightColor),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, FirstScreen.id);
                  },
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OnBoardPage extends StatelessWidget {
  final Column? bordcolumn;
  OnBoardPage({Key? key, this.bordcolumn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Center(child: bordcolumn),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100)))),
        ),
      ],
    );
  }
}
