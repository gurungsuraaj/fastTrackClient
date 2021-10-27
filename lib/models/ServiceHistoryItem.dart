class ServiceHistoryItem {
  String postingDate;
  String documentNo;
  String makeCode;
  String modelCode;
  String vehicleSerialNo;
  String locationCode;
  String no;
  String entryType;
  String vin;
  String userId;
  String customerId;
  String description;
  double quantity;
  double unitPrice;
  double totalAmount;

  ServiceHistoryItem(
      {this.postingDate,
      this.documentNo,
      this.makeCode,
      this.modelCode,
      this.vehicleSerialNo,
      this.locationCode,
      this.no,
      this.customerId,
      this.description,
      this.entryType,
      this.quantity,
      this.totalAmount,
      this.unitPrice,
      this.userId,
      this.vin});

  factory ServiceHistoryItem.fromJson(Map<String, dynamic> json) {
    return ServiceHistoryItem(
      postingDate: json['Posting_Date'],
      documentNo: json['Document_No'],
      makeCode: json['Make_Code'],
      modelCode: json['Model_Code'],
      vehicleSerialNo: json['Vehicle_Serial_No'],
      locationCode: json['Location_Code'],
      no: json['No'],
      description: json['Description'],
      totalAmount: json['Amount_Including_VAT'],
      customerId: json['Customer_No'],
      quantity: json['Quantity'],
      unitPrice: json['Unit_Cost'],
      userId: json['User_ID'],
      vin: json['VIN'],
      entryType: json['Entry_Type'],
    );
  }
}
