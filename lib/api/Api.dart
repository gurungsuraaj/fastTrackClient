class Api {
  static final String URL = "http://202.166.211.230:8099";
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
      "http://202.166.211.230:7747/DynamicsNAV/ws/FT%20Support/Page/UserListLocation";

  static final String SEND_NOTIFICATION = "https://fcm.googleapis.com/fcm/send";
  static final String URL_FOR_SEARCH_ITEM_FROM_NAV =
      "http://202.166.211.230:7747/DynamicsNAV/ws/FT%20Support/Page/ItemList";
  static final String CHECK_INVENTORY =
      "http://202.166.211.230:7747/DynamicsNAV/ws/FT%20Support/Codeunit/CheckInventory";
}
