import 'package:flutter/material.dart';

class ReusableAppBar {
  static getAppBar(double margin, double padding, double height, double width) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, margin, 0, margin),
      padding: EdgeInsets.fromLTRB(0, padding, 0, padding),

      // color: Color(0xff253983),
//    color: Colors.white,
      height: height / 4.5,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            // color: Colors.red,
            width: 310,
            child: Column(
              children: [
                // Container(
                //   margin: EdgeInsets.only(top: 30),
                //   child: Text(
                //     "Welcome to",
                //     style: TextStyle(
                //         fontSize: 30,
                //         fontWeight: FontWeight.w500,
                //         // fontStyle: FontStyle.italic,
                //         color: Colors.white),
                //   ),
                // ),
                // Container(
                //   // margin: EdgeInsets.only(bottom: 20),
                //   child: Text(
                //     "MY FASTTRACK",
                //     style: TextStyle(
                //         fontSize: 23,
                //         fontWeight: FontWeight.w800,
                //         // fontStyle: FontStyle.values(80),
                //         color: Colors.orange),
                //   ),
                // ),
                Container(
                  height: 130,
                  child: new Image.asset(
                    'images/fastTrack_launcher.png',
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
