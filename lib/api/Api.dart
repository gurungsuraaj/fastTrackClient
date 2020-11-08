class Api {
  static final String URL =
      "http://192.168.0.57:8099"; // This is intermediate link created by our dot net developer
  static final String BASE_URL =
      // "http://202.166.211.230:7747"; // This is the main url for both admin and client api
      // "http://192.168.0.57:7747"; // This is the main url for both admin and client api
      // "http://fatnav.dyndns.org:7047";
      "http://fatnav.dyndns.org:7347";

  static final String POST_CHECKINVENTORY =
      "$URL/api/FastrackPostApi/CheckInventory";
  static final String POST_CUSTOMER_SIGNUP =
      "$URL//api/FastrackPostApi/CustomerSignUp";
  static final String POST_CUSTOMER_LOGIN =
      "$URL//api/FastrackPostApi/Customerlogin";
  static final String LOCCATION_LIST = "$URL/api/FastrackPostApi/LocationList";
  static final String SEARCH_ITEM = "$URL/api/FastrackPostApi/ItemListSearch";
  static final String SERVICE_HISTORY_LIST =
      "$URL/api/FastrackPostApi/ReadMultipleServiceLedger";
  static final String ITEMLIST = "$URL/api/FastrackPostApi/ItemList";
  // static final String GET_ADMIN_USER_LIST_FOR_NOTIFICATION = "http://192.168.0.57:7747/DynamicsNAV/ws/FT%20Support/Page/UserListLocation";
  static final String GET_ADMIN_USER_LIST_FOR_NOTIFICATION =
      "$BASE_URL/DynamicsNAV/ws/Fasttrack/Page/UserListLocation";

  static final String SEND_NOTIFICATION = "https://fcm.googleapis.com/fcm/send";
  static final String URL_FOR_SEARCH_ITEM_FROM_NAV =
      "$BASE_URL/DynamicsNAV/ws/FT%20Support/Page/ItemList";
  static final String CHECK_INVENTORY =
      "$BASE_URL/DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory";
  static final String POSTED_SALES_INVOICE =
      "$BASE_URL/DynamicsNAV/ws/Fasttrack/Page/PostedSalesInvoiceList";
  // static final String WEB_SERVICE =
  //     "$BASE_URL/DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory";

  
    static final String WEB_SERVICE =
      "$BASE_URL/DynamicsNAV/ws/Fasttrack/Codeunit/CheckInventory";

      static final String VEHICLE_LIST =
      "$BASE_URL/DynamicsNAV/ws/Fasttrack/Page/VehicleList";

      static final String JOB_ORDER_PROCESS =
      "$BASE_URL/DynamicsNAV/WS/Fasttrack/Codeunit/JobOrderProcess";
}
