import 'dart:convert';

import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/models/CompanyInfoModel.dart';
import 'package:fasttrackgarage_app/models/CustomerModel.dart';
import 'package:fasttrackgarage_app/models/LoginModel.dart';
import 'package:fasttrackgarage_app/models/NetworkResponse.dart';
import 'package:fasttrackgarage_app/models/NextServiceDateModel.dart';
import 'package:fasttrackgarage_app/models/PostedSalesInvoiceModel.dart';
import 'package:fasttrackgarage_app/models/SearchItem.dart';
import 'package:fasttrackgarage_app/models/UserList.dart';
import 'package:fasttrackgarage_app/models/VehicleListModel.dart';
import 'package:fasttrackgarage_app/utils/Rcode.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntlm/ntlm.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class NetworkOperationManager {
  static Future<NetworkResponse> signUp(
      String mobileNum,
      String custName,
      String email,
      String password,
      String signature,
      NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    print(url);
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:SignUp>
<urn:mobileNo>$mobileNum</urn:mobileNo>
<urn:customerName>$custName</urn:customerName>
<urn:email>$email</urn:email>
<urn:passwordTxt>$password</urn:passwordTxt>
 <urn:signature>$signature</urn:signature>
 <urn:returnTxt></urn:returnTxt>
</urn:SignUp>
</soapenv:Body>
</soapenv:Envelope>''';
    print(envelope);

    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("status ${res.statusCode}  ${res.body}");
      var rawXmlResponse = res.body;
      var code = res.statusCode;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<LoginModel> logIn(
      String mobileNo, String passWord, NTLMClient client) async {
    var url = Uri.encodeFull(Api.webService);
    print("This is the url $url");
    Xml2Json xml2json = new Xml2Json();
    LoginModel loginModel = LoginModel();
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:Customerlogin>
<urn:mobileNo>$mobileNo</urn:mobileNo>
<urn:passwordTxt>$passWord</urn:passwordTxt>
<urn:customerNo></urn:customerNo>
<urn:customerName></urn:customerName>
<urn:custEmail></urn:custEmail>
</urn:Customerlogin>
</soapenv:Body>
</soapenv:Envelope>''';
    print(envelope);
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      // print("This is the response ${res.body}");
      /*  var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue = parsedXml.findAllElements("customerName");
      response = (resValue.map((node) => node.text)).first;

      rs.responseBody = response;
      rs.status = res.statusCode;*/

      var rawXmlResponse = res.body;
      var code = res.statusCode;
      print("STATUS: $code");
      loginModel.status = res.statusCode;

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        parsedXml.findAllElements("Customerlogin_Result").forEach((val) {
          xml2json.parse(val.toString());
          var json = xml2json.toParker();
          var data = jsonDecode(json);

          loginModel.customerNo = data['Customerlogin_Result']['customerNo'];
          loginModel.customerName =
              data['Customerlogin_Result']['customerName'];
          loginModel.customerEmail = data['Customerlogin_Result']['custEmail'];
        });
      } else {
        resValue = parsedXml.findAllElements("faultstring");

        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
        loginModel.errResponse = responseMessage;
      }
    });

    return loginModel;
  }

  static Future<List<UserList>> getAdminUserList(NTLMClient client) async {
    var url = Uri.encodeFull(Api.getAdminUserListForNoti);
    List<UserList> userArrayList = [];
    Xml2Json xml2json = new Xml2Json();
    print("This is the url $url");
    print("this is client ${client.username}");
    var envelope =
        '''<soap:Envelope xmlns:tns="urn:microsoft-dynamics-schemas/page/userlistlocation" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
<soap:Body>
<tns:ReadMultiple>
<tns:filter>
<tns:Field></tns:Field>
<tns:Criteria></tns:Criteria>
</tns:filter>
<tns:bookmarkKey></tns:bookmarkKey>
<tns:setSize></tns:setSize>
</tns:ReadMultiple>
</soap:Body>
</soap:Envelope>''';

    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/Page/UserListLocation",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");
      var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      parsedXml.findAllElements("UserListLocation").forEach((val) {
        UserList userList = new UserList();
        xml2json.parse(val.toString());
        var json = xml2json.toParker();
        var data = jsonDecode(json);
        userList.token = data["UserListLocation"]["Token"] ?? "";
        userList.latitude = data["UserListLocation"]["Latitude"] ?? "";
        userList.longitude = data["UserListLocation"]["Longitude"] ?? "";
        userList.userId = data["UserListLocation"]["User_ID"] ?? "";

        userList.statusCode = res.statusCode;
        //  print("This is Model Code inside loop ======> ${vehicleList.Model_Code}");
        userArrayList.add(userList);
      });
    });

    return userArrayList;
  }

  static Future<NetworkResponse> sendNotification(String token) async {
    // String url = Api.sendNotification;
    NetworkResponse rs = NetworkResponse();
    print(" Token $token");
    try {
      final body = jsonEncode({
        "to": token,
        "priority": "high",
        "notification": {
          "title": "Pleases response to the distress call!",
          "body": "Tap for more info!",
          "sound": "default",
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
        },
        "content-available": true,
        "data": {
          // 'status':'done',
          // 'id':'done',
          "title": "Pleases response to the distress call!",
          "body": "Tap for more info!",
          "click_action": "FLUTTER_NOTIFICATION_CLICK"
        },
      });

      print(body);

      await http
          .post('https://fcm.googleapis.com/fcm/send',
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAtSaXuEQ:APA91bGLDP8cG8WRPbkN6KXAxeVXkPLYrHJHJhMKeVU3fwxzGQ2njbYl2pS4XWP5zm_pPQJ8GkvHqYWzVKcC4D48lRZnnb9xbyxSLoYwBRVCIyOOpqRigh3Oze07bA5M6rLUhFGrjAdM',
              },
              body: body)
          .then((response) {
        print("Notification response ${response.statusCode} ${response.body}");

        rs.status = response.statusCode;
        rs.responseBodyForFireBase = jsonDecode(response.body);
      });
      return rs;

      // Map<String, String> header = {
      //   "Content-Type": "application/json",
      //   "Authorization":
      //       "key=AAAAtSaXuEQ:APA91bGLDP8cG8WRPbkN6KXAxeVXkPLYrHJHJhMKeVU3fwxzGQ2njbYl2pS4XWP5zm_pPQJ8GkvHqYWzVKcC4D48lRZnnb9xbyxSLoYwBRVCIyOOpqRigh3Oze07bA5M6rLUhFGrjAdM"
      // };
      // Map<String, String> notification = {
      //   "body": "Tap for more info!",
      //   "title": "Pleases response to the distress call",
      //   "sound": "default"
      // };
      // Map body = {"to": token, "notification": notification};
      // var bodyJson = json.encode(body);
      // debugPrint(" json body ${bodyJson}");

      // await http.post(url, headers: header, body: bodyJson).then((response) {
      //   rs.status = response.statusCode;
      //   debugPrint("${response.body}");
      //   rs.responseBodyForFireBase = jsonDecode(response.body);
      // });
      // return rs;
    } catch (e) {
      debugPrint("error $e");
      //throw Exception("$e");
    }
  }

  static Future<List<SearchItemModel>> searchItemFromNav(
      String search, NTLMClient client) async {
    var url = Uri.encodeFull(Api.urlSearchItemFromNav);
    // String response = "";
    List<SearchItemModel> searchItemArrayList = [];
    Xml2Json xml2json = new Xml2Json();
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tns="urn:microsoft-dynamics-schemas/page/itemlist">
<soapenv:Body>
<tns:ReadMultiple>
<tns:filter>
<tns:Field>Description</tns:Field>
<tns:Criteria>$search*</tns:Criteria>
</tns:filter>
<tns:bookmarkKey></tns:bookmarkKey>
<tns:setSize>100</tns:setSize>
</tns:ReadMultiple>
</soapenv:Body>
</soapenv:Envelope>''';
    print("This is the envelope $envelope");

    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/page/itemList",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");
      var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      parsedXml.findAllElements("ItemList").forEach((val) {
        SearchItemModel searchItemList = new SearchItemModel();
        xml2json.parse(val.toString());
        var json = xml2json.toParker();
        var data = jsonDecode(json);
        searchItemList.no = data["ItemList"]["No"] ?? "";
        searchItemList.description = data["ItemList"]["Description"] ?? "";

        searchItemList.unitprice = data["ItemList"]["Unit_Price"] ?? "";
        searchItemList.inventory = data["ItemList"]["Inventory"] ?? "";
        searchItemList.makeCode = data["ItemList"]["Make_Code"] ?? "";
        searchItemList.modelCode = data["ItemList"]["Model_Code"] ?? "";

        searchItemList.statusCode = res.statusCode;
        //  print("This is Model Code inside loop ======> ${vehicleList.Model_Code}");
        searchItemArrayList.add(searchItemList);
      });
    });

    return searchItemArrayList;
  }

  static Future<NetworkResponse> distressCall(
      String cusNumber, String cusName, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    // String response = "";
    print("This is the url $url");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-ddTkk:mm:ss').format(now);
    print("This is the now $formattedDate");

    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:Distresscall>
<urn:custName>$cusName</urn:custName>
<urn:custMobNo>$cusNumber</urn:custMobNo>
<urn:reqCallDateTime>$formattedDate</urn:reqCallDateTime>
</urn:Distresscall>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");
      rs.status = res.statusCode;
      /*  var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue = parsedXml.findAllElements("customerName");
      response = (resValue.map((node) => node.text)).first;

      rs.responseBody = response;
      rs.status = res.statusCode;*/
    });

    return rs;
  }

  static Future<List<SearchItemModel>> getItemFromBarcodeScanning(
      String search, NTLMClient client) async {
    var url = Uri.encodeFull(Api.urlSearchItemFromNav);
    // String response = "";
    List<SearchItemModel> searchItemArrayList = [];
    Xml2Json xml2json = new Xml2Json();
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tns="urn:microsoft-dynamics-schemas/page/itemlist">
<soapenv:Body>
<tns:ReadMultiple>
<tns:filter>
<tns:Field>Barcode_No</tns:Field>
<tns:Criteria>$search</tns:Criteria>
</tns:filter>
<tns:bookmarkKey></tns:bookmarkKey>
<tns:setSize>100</tns:setSize>
</tns:ReadMultiple>
</soapenv:Body>
</soapenv:Envelope>''';
    print("This is the envelope $envelope");

    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/page/itemList",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");
      var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      parsedXml.findAllElements("ItemList").forEach((val) {
        SearchItemModel searchItemList = new SearchItemModel();
        xml2json.parse(val.toString());
        var json = xml2json.toParker();
        var data = jsonDecode(json);
        searchItemList.no = data["ItemList"]["No"] ?? "";
        searchItemList.description = data["ItemList"]["Description"] ?? "";

        searchItemList.unitprice = data["ItemList"]["Unit_Price"] ?? "";
        searchItemList.inventory = data["ItemList"]["Inventory"] ?? "";
        searchItemList.makeCode = data["ItemList"]["Make_Code"] ?? "";
        searchItemList.modelCode = data["ItemList"]["Model_Code"] ?? "";

        searchItemList.statusCode = res.statusCode;
        //  print("This is Model Code inside loop ======> ${vehicleList.Model_Code}");
        searchItemArrayList.add(searchItemList);
      });
    });

    return searchItemArrayList;
  }

  static Future<List<PostedSalesInvoiceModel>> getPostedSalesInvoiceList(
      String custNumber, NTLMClient client) async {
    var url = Uri.encodeFull(Api.postedSalesInvoice);
    Xml2Json xml2json = new Xml2Json();
    List<PostedSalesInvoiceModel> postedSalesList = [];
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tns="urn:microsoft-dynamics-schemas/page/postedsalesinvoicelist">
<soapenv:Body>
<tns:ReadMultiple>
<tns:filter>
<tns:Field>Sell_to_Customer_No</tns:Field>
<tns:Criteria>$custNumber</tns:Criteria>
</tns:filter>
<tns:bookmarkKey></tns:bookmarkKey>
<tns:setSize>50</tns:setSize>
</tns:ReadMultiple>
</soapenv:Body>
</soapenv:Envelope>''';
    print("This is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction":
            "urn:microsoft-dynamics-schemas/page/postedsalesinvoicelist",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");
      var rawXmlResponse = res.body.toString();
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      parsedXml.findAllElements("PostedSalesInvoiceList").forEach((val) {
        PostedSalesInvoiceModel postedSalesItem = new PostedSalesInvoiceModel();
        xml2json.parse(val.toString());
        var json = xml2json.toParker();
        var data = jsonDecode(json);
        print("val");
        postedSalesItem.no = data["PostedSalesInvoiceList"]["No"] ?? "";
        postedSalesItem.sellToCustomerNo =
            data["PostedSalesInvoiceList"]["Sell_to_Customer_No"] ?? "";
        postedSalesItem.sellToCustomerName =
            data["PostedSalesInvoiceList"]["Sell_to_Customer_Name"] ?? "";
        postedSalesItem.amt = data["PostedSalesInvoiceList"]["Amount"] ?? "";
        postedSalesItem.amtIncVat =
            data["PostedSalesInvoiceList"]["Amount_Including_VAT"] ?? "";
        postedSalesItem.billToCustomerNo =
            data["PostedSalesInvoiceList"]["Bill_to_Customer_No"] ?? "";
        postedSalesItem.billToName =
            data["PostedSalesInvoiceList"]["Bill_to_Name"] ?? "";
        postedSalesItem.shipToName =
            data["PostedSalesInvoiceList"]["Ship_to_Name"] ?? "";
        postedSalesItem.postDate =
            data["PostedSalesInvoiceList"]["Posting_Date"] ?? "";
        postedSalesItem.locationCode =
            data["PostedSalesInvoiceList"]["Location_Code"] ?? "";
        postedSalesItem.documentDate =
            data["PostedSalesInvoiceList"]["Document_Date"] ?? "";
        postedSalesItem.dueDate =
            data["PostedSalesInvoiceList"]["Due_Date"] ?? "";
        postedSalesItem.paymentDiscountPercent =
            data["PostedSalesInvoiceList"]["Payment_Discount_Percent"] ?? "";
        postedSalesItem.shipmentDate =
            data["PostedSalesInvoiceList"]["Shipment_Date"] ?? "";
        postedSalesItem.smsSend =
            data["PostedSalesInvoiceList"]["SMS_Sent"] ?? "";
        postedSalesItem.serviceOrder =
            data["PostedSalesInvoiceList"]["Service_Order_No"] ?? "";
        postedSalesItem.locationName =
            data["PostedSalesInvoiceList"]["LocationName"] ?? "";

        postedSalesList.add(postedSalesItem);
      });
    });

    return postedSalesList;
  }

  static Future<NetworkResponse> generateOTP(
      String email, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    // String response = "";
    print("This is the url $url");

    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:CustomerGenerateOTP>
<urn:customerEmail>$email</urn:customerEmail>
</urn:CustomerGenerateOTP>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("return_value");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });
    return rs;
  }

  static Future<NetworkResponse> submitOTP(
      String email, String otp, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    // String response = "";
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:CustomerOTPVerification>
<urn:mobileNo>$email</urn:mobileNo>
<urn:customerOTP>$otp</urn:customerOTP>
<urn:returnTxt></urn:returnTxt>
</urn:CustomerOTPVerification>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<NetworkResponse> saveNewPassword(
      String mobile, String password, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    // String response = "";
    print("This is the url $url");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-ddTkk:mm:ss').format(now);
    print("This is the now $formattedDate");

    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:CustomerSavePassword>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:customerPassword>$password</urn:customerPassword>
<urn:returnTxt></urn:returnTxt>
</urn:CustomerSavePassword>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<List<VehicleListModel>> getVehicleList(
      String customerNumber, NTLMClient client) async {
    // NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.vehicleList);
    // String response = "";
    List<VehicleListModel> vehicleArrayList = [];
    Xml2Json xml2json = new Xml2Json();
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tns="urn:microsoft-dynamics-schemas/page/vehiclelist">
<soapenv:Body>
<tns:ReadMultiple>
<tns:filter>
<tns:Field>Customer_No</tns:Field>
<tns:Criteria>$customerNumber</tns:Criteria>
</tns:filter>
<tns:bookmarkKey></tns:bookmarkKey>
<tns:setSize></tns:setSize>
</tns:ReadMultiple>
</soapenv:Body>
</soapenv:Envelope>''';
    print(envelope);
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/page/vehiclelist",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");
      var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      parsedXml.findAllElements("VehicleList").forEach((val) {
        VehicleListModel vehicleList = new VehicleListModel();
        // print("This is loop $val");
        xml2json.parse(val.toString());
        var json = xml2json.toParker();
        var data = jsonDecode(json);
        vehicleList.Customer_No = data["VehicleList"]["Customer_No"] ?? "";
        vehicleList.Make_Code = data["VehicleList"]["Make_Code"] ?? "";
        vehicleList.VIN = data["VehicleList"]["VIN"] ?? "";
        vehicleList.Model_Code = data["VehicleList"]["Model_Code"] ?? "";
        vehicleList.vehicleCode =
            data["VehicleList"]["Variable_Field_25006800"] ?? "";
        vehicleList.vehicleEmirates =
            data["VehicleList"]["Variable_Field_25006802"] ?? "";
        vehicleList.vehicleCategory =
            data["VehicleList"]["Variable_Field_25006801"] ?? "";
        vehicleList.Serial_No = data["VehicleList"]["Serial_No"] ?? "";
        vehicleList.Type_Code = data["VehicleList"]["Type_Code"] ?? "";
        vehicleList.Registration_No =
            data["VehicleList"]["Registration_No"] ?? "";
        vehicleList.Production_Year =
            data["VehicleList"]["Production_Year"] ?? "";
        vehicleList.odometer = data["VehicleList"]["Kilometrage"] ?? "";
        vehicleList.StatusCode = res.statusCode;

        //  print("This is Model Code inside loop ======> ${vehicleList.Model_Code}");
        vehicleArrayList.add(vehicleList);
      });
    });

    return vehicleArrayList;
  }

  static Future<List<CompanyInfoModel>> getCompanyInfo(
      NTLMClient client) async {
    var url = Uri.encodeFull(Api.getCompanyInfo);
    String response = "";
    List<CompanyInfoModel> companyInfoArrayList = [];
    Xml2Json xml2json = new Xml2Json();
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tns="urn:microsoft-dynamics-schemas/page/companyinformation">
<soapenv:Body>
<tns:ReadMultiple>
<tns:filter>
<tns:Field></tns:Field>
<tns:Criteria></tns:Criteria>
</tns:filter>
<tns:bookmarkKey></tns:bookmarkKey>
<tns:setSize></tns:setSize>
</tns:ReadMultiple>
</soapenv:Body>
</soapenv:Envelope>''';
    print(envelope);
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/page/companyinformation",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");
      var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      parsedXml.findAllElements("CompanyInformation").forEach((val) {
        CompanyInfoModel companyInfoList = new CompanyInfoModel();
        xml2json.parse(val.toString());
        var json = xml2json.toParker();
        var data = jsonDecode(json);
        companyInfoList.serviceDateComment =
            data["CompanyInformation"]["Service_Date_Comment"] ?? "";
        companyInfoList.androidVersion =
            data["CompanyInformation"]["Android_Version_No"] ?? "";
        companyInfoList.iOSversionNo =
            data["CompanyInformation"]["IOS_Version_No"] ?? "";
        companyInfoList.appStoreUrl =
            data["CompanyInformation"]["AppStore_Url"] ?? "";
        companyInfoList.playStoreUrl =
            data["CompanyInformation"]["PlayStore_Url"] ?? "";
        companyInfoList.statusCode = res.statusCode;
        companyInfoList.lapseServiceMessage =
            data["CompanyInformation"]["Lapse_Service_Date_Message"];
        companyInfoArrayList.add(companyInfoList);
      });
      print("This is response body: $response");
    });

    return companyInfoArrayList;
  }

  static Future<NextServiceDateModel> checkServiceDate(String customerNo,
      String vehicleSerialNo, String regNo, NTLMClient client) async {
    var url = Uri.encodeFull(Api.jobOrderProcess);
    // String response = "";
    print("This is the url $url");
    NextServiceDateModel nextServiceData = NextServiceDateModel();
    Xml2Json xml2json = new Xml2Json();
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/JobOrderProcess">
<soapenv:Body>
<urn:CheckNextServiceDateApp>
<urn:customerNo>$customerNo</urn:customerNo>
<urn:vehicalSerialNo>$vehicleSerialNo</urn:vehicalSerialNo>
<urn:nextServiceDate>0001-01-01</urn:nextServiceDate>
<urn:locationName></urn:locationName>
<urn:phoneNo></urn:phoneNo>
</urn:CheckNextServiceDateApp>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/JobOrderProcess",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      // var responseMessage;
      if (code == Rcode.successCode) {
        parsedXml
            .findAllElements("CheckNextServiceDateApp_Result")
            .forEach((val) {
          xml2json.parse(val.toString());
          var json = xml2json.toParker();
          var data = jsonDecode(json);
          nextServiceData.status = res.statusCode;
          nextServiceData.locationName =
              data["CheckNextServiceDateApp_Result"]["locationName"] ?? "";
          nextServiceData.phoneNumber =
              data["CheckNextServiceDateApp_Result"]["phoneNo"] ?? "";
          nextServiceData.vehicleSerialNo = vehicleSerialNo;
          nextServiceData.nextServiceDate =
              data["CheckNextServiceDateApp_Result"]["nextServiceDate"] ?? "";
          nextServiceData.registerNo = regNo;
        });
        // formattedResVal = resValue.map((node) => node.text);
        // responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        nextServiceData.faultString = formattedResVal.first;
        nextServiceData.status = res.statusCode;
      }
    });

    return nextServiceData;
  }

  static Future<NetworkResponse> submitSignUpOTP(
      String mobile, String otp, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    // String response = "";
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:MobileOTPVerification>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:customerOTP>$otp</urn:customerOTP>
<urn:returnTxt></urn:returnTxt>
</urn:MobileOTPVerification>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<NetworkResponse> resendOtpForSignUp(
      String mobile, String signature, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    // String response = "";
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:ResendOTP>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:signature>$signature</urn:signature>
<urn:returnTxt></urn:returnTxt>
</urn:ResendOTP>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<NetworkResponse> forgotPassOtp(
      String mobile, String signature, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:CustomerForgotPassword>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:signature>$signature</urn:signature>
<urn:returnTxt></urn:returnTxt>
</urn:CustomerForgotPassword>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<NetworkResponse> resendOtpForForgetPw(
      String mobile, String signature, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:CustomerResendOTP>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:signature>$signature</urn:signature>
<urn:returnTxt></urn:returnTxt>
</urn:CustomerResendOTP>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<CustomerModel> getCustomerList(
      String mobileNumber, NTLMClient client) async {
    var url = Uri.encodeFull(Api.customerList);
    Xml2Json xml2json = new Xml2Json();
    print("This is the url $url");
    CustomerModel customerModel = new CustomerModel();
    var envelope =
        '''<soap:Envelope xmlns:tns="urn:microsoft-dynamics-schemas/page/customerlist" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
    <soap:Body>
        <tns:ReadMultiple>
            <tns:filter>
                <tns:Field>Mobile_No</tns:Field>
                <tns:Criteria>$mobileNumber</tns:Criteria>
            </tns:filter>
            <tns:setSize>1</tns:setSize>
        </tns:ReadMultiple>
    </soap:Body>
</soap:Envelope>''';

    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/page/customerlist",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      print("This is the response ${res.body}");

      var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      parsedXml.findAllElements("CustomerList").forEach((val) {
        xml2json.parse(val.toString());
        var json = xml2json.toParker();
        var data = jsonDecode(json);
        customerModel.name = data["CustomerList"]["Name"] ?? "";
        customerModel.phoneNumber = data["CustomerList"]["Mobile_No"] ?? "";
        customerModel.email = data["CustomerList"]["E_Mail"] ?? "";
        customerModel.password = data["CustomerList"]["Password"] ?? "";
        customerModel.customerNo = data["CustomerList"]["No"] ?? "";

        customerModel.status = res.statusCode;
      });
    });

    return customerModel;
  }

  static Future<NetworkResponse> sendExistingCustomerOTP(
      String mobile, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:SendCustomerOTP>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:returnTxt></urn:returnTxt>
</urn:SendCustomerOTP>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        print("Suraj");

        resValue = parsedXml.findAllElements("SendCustomerOTP_Result");
        formattedResVal = resValue.map((node) => node.text);
        print("Suraj 1");

        responseMessage = formattedResVal.first;
        print("Suraj 2");
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });

    return rs;
  }

  static Future<NetworkResponse> resendExistingCustomerOTP(
      String mobile, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:ResendCustomerOTP>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:returnTxt></urn:returnTxt>
</urn:ResendCustomerOTP>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });
    return rs;
  }

  static Future<NetworkResponse> verifyExistingCustomerOTP(
      String mobile,
      String customerName,
      String email,
      String password,
      String otp,
      NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:VerifiyCustomerOTP>
<urn:mobileNo>$mobile</urn:mobileNo>
<urn:customerName>$customerName</urn:customerName>
<urn:email>$email</urn:email>
<urn:passwordTxt>$password</urn:passwordTxt>
<urn:customerOTP>$otp</urn:customerOTP>
<urn:returnTxt></urn:returnTxt>
</urn:VerifiyCustomerOTP>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      print("URL: $url");
      var code = res.statusCode;
      print("STATUS: $code");
      print("RESPONSE: $rawXmlResponse");

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("returnTxt");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }

      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });
    return rs;
  }

  static Future<NetworkResponse> sendCheckHistoryEmail(
      String invoiceNo, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.webService);
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:SendSalesInvoiceReport>
<urn:invoiceNo>$invoiceNo</urn:invoiceNo>
<urn:status></urn:status>
</urn:SendSalesInvoiceReport>
</soapenv:Body>
</soapenv:Envelope>''';
    debugPrint(" this is the envelope $envelope");
    await client
        .post(
      url,
      headers: {
        "Content-Type": "text/xml",
        "Accept-Charset": "utf-8",
        "SOAPAction": "urn:microsoft-dynamics-schemas/codeunit/CheckInventory",
      },
      body: envelope,
      encoding: Encoding.getByName("UTF-8"),
    )
        .then((res) {
      var rawXmlResponse = res.body;
      var code = res.statusCode;

      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue;
      var formattedResVal;
      var responseMessage;
      if (code == Rcode.successCode) {
        resValue = parsedXml.findAllElements("status");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      } else {
        resValue = parsedXml.findAllElements("faultstring");
        formattedResVal = resValue.map((node) => node.text);
        responseMessage = formattedResVal.first;
      }
      rs.status = res.statusCode;
      rs.responseBody = responseMessage;
    });
    return rs;
  }
}
