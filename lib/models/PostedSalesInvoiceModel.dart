class PostedSalesInvoiceModel {
  String no;
  String sellToCustomerNo;
  String sellToCustomerName;
  String amt;
  String amtIncVat;
  String billToCustomerNo;
  String billToName;
  String shipToName;
  String postDate;
  String locationCode;
  String documentDate;
  String dueDate;
  String paymentDiscountPercent;
  String shipmentDate;
  String smsSend;
  String serviceOrder;
  String locationName;


  PostedSalesInvoiceModel(
      {this.no,
      this.sellToCustomerNo,
      this.sellToCustomerName,
      this.amt,
      this.amtIncVat,
      this.billToCustomerNo,
      this.billToName,
      this.shipToName,
      this.postDate,
      this.locationCode,
      this.documentDate,
      this.dueDate,
      this.paymentDiscountPercent,
      this.shipmentDate,
      this.smsSend,
      this.serviceOrder,this.locationName});
}
