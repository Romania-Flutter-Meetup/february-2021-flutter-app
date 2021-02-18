import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './login.dart';
import '../utilities/styles.dart';

class LaunchTutorialScreen extends StatefulWidget {
  @override
  _LaunchTutorialScreenState createState() => _LaunchTutorialScreenState();
}

class _LaunchTutorialScreenState extends State<LaunchTutorialScreen> {
  int _slideIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  String sliderImagesPath = 'assets/images/';
  List<String> sliderImages = [
    'slide_1.jpg',
    'slide_2.jpg',
    'slide_3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    int totalPages = OnBoardingItems.loadOnboardingItem().length;
    PageController _controller = PageController(
      initialPage: 0,
    );

    return WillPopScope(
      onWillPop: () {
        return new Future(() => false);
      },
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            PageView.builder(
              onPageChanged: (index) {
                setState(() {
                  _slideIndex = index;
                });
              },
              controller: _controller,
              itemCount: totalPages,
              itemBuilder: (BuildContext context, int index) {
                OnBoardingItem oi = OnBoardingItems.loadOnboardingItem()[index];
                return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.5), BlendMode.darken),
                      image: AssetImage(sliderImagesPath + sliderImages[index]),
                      fit: BoxFit.fill,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          oi.title,
                          style: kTitleStyle,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          oi.subtitle,
                          style: kSubtitleStyle,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      ),
                      MaterialButton(
                        onPressed: () {
                          _setFirstTimeAccess();

                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ),
                          );
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            getNavigationText(index),
                            style: kTitleStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Stack(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 100),
                        width: MediaQuery.of(context).size.width / 3,
                        height: 30,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: totalPages,
                          itemBuilder: (BuildContext context, int i) {
                            return GestureDetector(
                              onTap: () {
                                _controller.animateToPage(
                                  i,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                                log('Jumping to next slide ' + i.toString());
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5.0, 10, 5.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: _slideIndex == i
                                        ? Colors.white70
                                        : Colors.white30,
                                    borderRadius: new BorderRadius.all(
                                      const Radius.circular(30),
                                    ),
                                  ),
                                  width: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getNavigationText(int index) {
    String navigationText = "sari";

    if (index == sliderImages.length - 1) {
      navigationText = "continua";
    }

    return navigationText;
  }

  void _setFirstTimeAccess() async {
    print('Setting up first time access');
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('first_time_load', 'true');
  }
}

class OnBoardingItem {
  final String title;
  final String subtitle;
  final String image;
  final Color color;

  const OnBoardingItem({this.title, this.subtitle, this.image, this.color});
}

class OnBoardingItems {
  static List<OnBoardingItem> loadOnboardingItem() {
    const fi = <OnBoardingItem>[
      OnBoardingItem(
        title: "Bun venit!",
        subtitle:
            "Non malesuada elementum risus tortor in. Ac non donec hendrerit eget risus, vivamus eget viverra mauris. Adipiscing sed ornare eget quis dictum felis quis et semper. Feugiat enim, eu arcu sagittis.",
        image:
            "https://raw.githubusercontent.com/Ethiel97/flutter_slides/part-one-building-the-screens/assets/slide_1.png",
        color: Colors.blue,
      ),
      OnBoardingItem(
        title: "Lorem ipsum",
        subtitle:
            "Commodo auctor egestas auctor dictum mattis dignissim viverra commodo. Nisl dolor, in nisl turpis duis condimentum odio nisl integer. Purus at augue varius dui, diam tellus fermentum.",
        image:
            "https://raw.githubusercontent.com/Ethiel97/flutter_slides/part-one-building-the-screens/assets/slide_1.png",
        color: Colors.green,
      ),
      OnBoardingItem(
        title: "Semper eget",
        subtitle:
            "Lacus posuere sed laoreet venenatis bibendum mollis at. Cursus aliquet justo, netus volutpat malesuada ornare a lorem. Pellentesque et posuere eget arcu pharetra, eget elit, morbi ullamcorper facilisis.",
        image:
            "https://raw.githubusercontent.com/Ethiel97/flutter_slides/part-one-building-the-screens/assets/slide_1.png",
        color: Colors.orange,
      ),
    ];
    return fi;
  }
}
