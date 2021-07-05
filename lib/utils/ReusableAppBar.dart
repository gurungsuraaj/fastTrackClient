import 'package:flutter/material.dart';

class ReusableAppBar {
  static getAppBar(double margin, double padding, double height, double width) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, margin, 0, margin),
      padding:EdgeInsets.fromLTRB(0, padding, 0, padding),

      color: Color(0xff253983),
//    color: Colors.white,
      height: height / 4,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          // color: Colors.red,
            width: 310,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "My Fasttrack",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                ),
                Container(
                  height: 100,
                  child: new Image.asset(
                    'images/fastTrackSplashLogo.png',
                  ),
                ),
              ],
            )

            //  new Image(
            //   // image: AssetImage(
            //   //   'images/fast_track_logo.png',
            //   // ),
            //   image: AssetImage(
            //     'images/fastTrackSplashLogo.png',
            //   ),
            // ),
            ),
      ),
    );
  }
}
