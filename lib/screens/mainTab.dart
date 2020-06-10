import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/NotificationScreen.dart';
import 'package:fasttrackgarage_app/screens/UsersProfileActivity.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:flutter/material.dart';

import 'OfferPromo.dart';
import 'StoreLocationScreen.dart';

class MainTab extends StatefulWidget {
  @override
  _MainTabState createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  int bottomSelectedIndex = 0;
  var bottomTabBarText = TextStyle(fontSize: 12);


  PageController pageController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: buildPageView(),
      bottomNavigationBar: Container(

        child: BottomNavigationBar(

          currentIndex: bottomSelectedIndex,
          onTap: (index) {
            bottomTapped(index);
          },
          items: buildBottomNavBarItems(),
        ),
      ),


    );
  }


  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HomeActivity(),
        UsersProfileActivity(),
        NotificationScreen(),
        StoreLocationScreen(),
        OfferPromo(),

//        HomeButtons(),
//        RequestButtons(),
//        PendingButtons(),
//        MessageButtons(),
//        ProfileButtons()
      ],
    );
  }
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }
  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home,color: Color(ExtraColors.DARK_BLUE),),
          title: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: new Text(
              'Home',
              style: bottomTabBarText,
            ),
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.person,color: Color(ExtraColors.DARK_BLUE)),
          title: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              'Profile',
              style: bottomTabBarText,
            ),
          )),
      BottomNavigationBarItem(
        icon: new Icon(Icons.notifications,color: Color(ExtraColors.DARK_BLUE)),
        title: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: new Text(
            'Request',
            style: bottomTabBarText,
          ),
        ),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.location_on,color: Color(ExtraColors.DARK_BLUE)),
          title: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              'Pending',
              style: bottomTabBarText,
            ),
          )),
      BottomNavigationBarItem(
          icon: Icon(Icons.view_carousel,color: Color(ExtraColors.DARK_BLUE)),
          title: Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              'Message',
              style: bottomTabBarText,
            ),
          )),

    ];
  }
  void bottomTapped(int index) {
    debugPrint("this is index");
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

}
