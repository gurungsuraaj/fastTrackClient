import 'package:fasttrackgarage_app/screens/GenerateOTPActivity.dart';
import 'package:fasttrackgarage_app/screens/HomeActivity.dart';
import 'package:fasttrackgarage_app/screens/InventoryCheckActivity.dart';
import 'package:fasttrackgarage_app/screens/OTPActivity.dart';
import 'package:fasttrackgarage_app/screens/OutletActivity.dart';
import 'package:fasttrackgarage_app/screens/ServiceActivity.dart';
import 'package:fasttrackgarage_app/screens/ServiceHistoryActivity.dart';
import 'package:fasttrackgarage_app/screens/SignUpActivity.dart';
import 'package:fasttrackgarage_app/utils/RoutesName.dart';
import 'package:fasttrackgarage_app/screens/LoginActivity.dart';

import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginActivity(),
        routes: <String, WidgetBuilder>{
          RoutesName.SIGNUP_ACTIVITY: (BuildContext context) =>
              new LoginActivity(),
          RoutesName.SIGNUP_ACTIVITY: (BuildContext context) =>
              new SignUpActivity(),
          RoutesName.OTP_ACTIVITY: (BuildContext context) => new OTP(),
          RoutesName.GENERATE_OTP_ACTIVITY: (BuildContext context) =>
              new GenerateOTP(),
          RoutesName.HOME_ACTIVITY: (BuildContext context) => new Home(),
          RoutesName.INVENTORY_CHECK_ACTIVITY: (BuildContext context) =>
              new InventoryCheckActivity(),
          RoutesName.OUTLET_ACTIVITY: (BuildContext context) =>
              new OutletActivity(),
          RoutesName.SERVICE_HISTORY_ACTIVITY: (BuildContext context) =>
              new ServiceHistoryActivity(),
          RoutesName.SERVICE_ACTIVITY: (BuildContext context) =>
              new ServiceActivity(),
        },
      ),
    );
