import 'dart:convert';

import 'package:fasttrackgarage_app/models/Promo.dart';
import 'package:fasttrackgarage_app/utils/ExtraColors.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class OfferPromo extends StatefulWidget {
  OfferPromo({Key key}) : super(key: key);

  @override
  _OfferPromoState createState() => _OfferPromoState();
}

class _OfferPromoState extends State<OfferPromo> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isProgressBarShown = false;

  List<Promo> promoList = new List<Promo>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showOffer();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(ExtraColors.DARK_BLUE),
        title: Text("Offers and Promotion"),
      ),
      backgroundColor: Color(0xFFD9D9D9),
      body: ModalProgressHUD(
        inAsyncCall: isProgressBarShown,
        child: ListView.builder(
          itemCount: promoList.length,
          itemBuilder: (context, index) {
            return Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Image.network(
                promoList[index].banner,
                fit: BoxFit.fitWidth,
                // height: 190,
              ),
            );
          },
        ),
      ),
    );
  }

  showOffer() async {
    showProgressBar();
    Map<String, String> header = {
      "Content-Type": "application/json",
    };

    // This is the URL for getting promo images
    await http
        .get("https://www.fasttrackemarat.com/feed/promotions.json",
            headers: header)
        .then((res) {
      int status = res.statusCode;
      if (status == Rcode.SUCCESS_CODE) {
        hideProgressBar();

        var result = json.decode(res.body);
        var values = result["promotions"] as List;
        setState(() {
          // All the images from the API is save to the promo list.
          promoList =
              values.map<Promo>((json) => Promo.fromJson(json)).toList();
        });
      } else {
        hideProgressBar();

        displaySnackbar(context, "An error has occured ");
      }
    });
  }

  Future<void> displaySnackbar(BuildContext context, msg) {
    final snackBar = SnackBar(
      content: Text('$msg'),
      duration: const Duration(seconds: 2),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showProgressBar() {
    setState(() {
      isProgressBarShown = true;
    });
  }

  void hideProgressBar() {
    setState(() {
      isProgressBarShown = false;
    });
  }
}
