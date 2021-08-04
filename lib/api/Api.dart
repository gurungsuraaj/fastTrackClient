class Api {
  static final String url =
      "http://192.168.0.57:8099"; // This is intermediate link created by our dot net developer
  static final String baseUrl =
      // "http://202.166.211.230:7747"; // This is the main url for both admin and client api
      // "http://192.168.0.57:7747"; // This is the main url for both admin and client api
      // "http://fatnav.dyndns.org:7047"; // Live
  "http://fatnav.dyndns.org:7347";  //Dev

  static final String postCheckInventory =
      "$url/api/FastrackPostApi/CheckInventory";
  static final String postCustomerSignUp =
      "$url//api/FastrackPostApi/CustomerSignUp";
  static final String postCustomerLogin =
      "$url//api/FastrackPostApi/Customerlogin";
  static final String locationList = "$url/api/FastrackPostApi/LocationList";
  static final String searchItem = "$url/api/FastrackPostApi/ItemListSearch";
  static final String serviceHistoryList =
      "$url/api/FastrackPostApi/ReadMultipleServiceLedger";
  static final String itemList = "$url/api/FastrackPostApi/ItemList";
  // static final String GET_ADMIN_USER_LIST_FOR_NOTIFICATION = "http://192.168.0.57:7747/DynamicsNAV/ws/FT%20Support/Page/UserListLocation";
  static final String getAdminUserListForNoti =
      "$baseUrl/DynamicsNAV/ws/Fasttrack/Page/UserListLocation";

  static final String sendNotification = "https://fcm.googleapis.com/fcm/send";
  static final String urlSearchItemFromNav =
      "$baseUrl/DynamicsNAV/ws/FT%20Support/Page/ItemList";
  static final String checkInventory =
      "$baseUrl/DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory";
  static final String postedSalesInvoice =
      "$baseUrl/DynamicsNAV/ws/Fasttrack/Page/PostedSalesInvoiceList";
  static final String getCompanyInfo =
      "$baseUrl/DynamicsNAV/ws/Fasttrack/Page/CompanyInformation";
  // static final String WEB_SERVICE =
  //     "$baseUrl/DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory";

  static final String webService =
      "$baseUrl/DynamicsNAV/ws/Fasttrack/Codeunit/CheckInventory";

  static final String vehicleList =
      "$baseUrl/DynamicsNAV/ws/Fasttrack/Page/VehicleList";

  static final String jobOrderProcess =
      "$baseUrl/DynamicsNAV/WS/Fasttrack/Codeunit/JobOrderProcess";

  static final String customerList =
      "$baseUrl/DynamicsNAV/ws/Fasttrack/Page/CustomerList";
}
