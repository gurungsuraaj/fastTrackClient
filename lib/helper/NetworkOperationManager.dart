import 'dart:convert';

import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/models/NetworkResponse.dart';
import 'package:fasttrackgarage_app/models/SearchItem.dart';
import 'package:fasttrackgarage_app/models/UserList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntlm/ntlm.dart';
import 'package:xml/xml.dart' as xml;
import 'package:xml2json/xml2json.dart';
import 'package:http/http.dart' as http;

class NetworkOperationManager {
  static Future<NetworkResponse> signUp(NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Api.POST_CHECKINVENTORY;
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:LoginStaff>
<urn:staffID>101</urn:staffID>
</urn:LoginStaff>
</soapenv:Body>
</soapenv:Envelope>''';

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
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue = parsedXml.findAllElements("return_value");
      String response = (resValue.map((node) => node.text)).first;

      rs.responseBody = response;
      rs.status = res.statusCode;
    });

    return rs;
  }

  static Future<NetworkResponse> logIn(String mobileNo, String passWord,
      String cusNumber, String cusName, String email, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.POST_CHECKINVENTORY);
    String response = "";
    print("This is the url $url");
    var envelope =
        '''<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:microsoft-dynamics-schemas/codeunit/CheckInventory">
<soapenv:Body>
<urn:Customerlogin>
<urn:mobileNo>$mobileNo</urn:mobileNo>
<urn:passwordTxt>$passWord</urn:passwordTxt>
<urn:customerNo>$cusNumber</urn:customerNo>
<urn:customerName>$cusName</urn:customerName>
<urn:custEmail>$email</urn:custEmail>
</urn:Customerlogin>
</soapenv:Body>
</soapenv:Envelope>''';

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
      /*  var rawXmlResponse = res.body;
      xml.XmlDocument parsedXml = xml.parse(rawXmlResponse);
      var resValue = parsedXml.findAllElements("customerName");
      response = (resValue.map((node) => node.text)).first;

      rs.responseBody = response;
      rs.status = res.statusCode;*/
    });

    return rs;
  }

  static Future<List<UserList>> getAdminUserList(NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.GET_ADMIN_USER_LIST_FOR_NOTIFICATION);
    String response = "";
    List<UserList> userArrayList = new List();
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
    String url = Api.SEND_NOTIFICATION;
    NetworkResponse rs = NetworkResponse();

    try {
      Map<String, String> header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAtSaXuEQ:APA91bGLDP8cG8WRPbkN6KXAxeVXkPLYrHJHJhMKeVU3fwxzGQ2njbYl2pS4XWP5zm_pPQJ8GkvHqYWzVKcC4D48lRZnnb9xbyxSLoYwBRVCIyOOpqRigh3Oze07bA5M6rLUhFGrjAdM"
      };
      Map<String, String> notification = {
        "body": "Tap for more info!",
        "title": "Pleases response to the distress call",
        "sound": "default"
      };
      Map body = {"to": token, "notification": notification};
      var bodyJson = json.encode(body);
      debugPrint(" json body ${bodyJson}");

      await http.post(url, headers: header, body: bodyJson).then((response) {
        rs.status = response.statusCode;
        debugPrint("${response.body}");
        rs.responseBodyForFireBase = jsonDecode(response.body);
      });
      return rs;
    } catch (e) {
      debugPrint("error $e");
      //throw Exception("$e");
    }
  }

  static Future<List<SearchItemModel>> searchItemFromNav(
      String search, NTLMClient client) async {
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.URL_FOR_SEARCH_ITEM_FROM_NAV);
    String response = "";
    List<SearchItemModel> searchItemArrayList = new List();
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
    var url = Uri.encodeFull(Api.CHECK_INVENTORY);
    String response = "";
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
    NetworkResponse rs = new NetworkResponse();
    var url = Uri.encodeFull(Api.URL_FOR_SEARCH_ITEM_FROM_NAV);
    String response = "";
    List<SearchItemModel> searchItemArrayList = new List();
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
}
