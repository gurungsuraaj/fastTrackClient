class PostedSalesInvoiceModel {
  String no;
  String sellToCustomerNo;
  String sellToCustomerName;
  String amt;
  String amt_inc_VAT;
  String bill_to_customerNo;
  String bill_to_name;
  String ship_to_name;
  String post_date;
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
      this.amt_inc_VAT,
      this.bill_to_customerNo,
      this.bill_to_name,
      this.ship_to_name,
      this.post_date,
      this.locationCode,
      this.documentDate,
      this.dueDate,
      this.paymentDiscountPercent,
      this.shipmentDate,
      this.smsSend,
      this.serviceOrder,this.locationName});
}
