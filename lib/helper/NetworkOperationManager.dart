import 'dart:convert';

import 'package:fasttrackgarage_app/api/Api.dart';
import 'package:fasttrackgarage_app/models/NetworkResponse.dart';
import 'package:ntlm/ntlm.dart';
import 'package:xml/xml.dart' as xml;

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

  static Future<NetworkResponse> logIn(String mobileNo, String passWord, String cusNumber, String cusName, String email, NTLMClient client) async {
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
}
