class ServiceHistoryItem {
  String Posting_Date;
  String Document_No;
  String Make_Code;
  String Model_Code;
  String Vehicle_Serial_No;
  String Location_Code;
  String No;
  String entryType;
  String vin;
  String userId;
  String customerId;
  String description;
  double quantity;
  double unitPrice;
  double totalAmount;

  ServiceHistoryItem(
      {this.Posting_Date,
      this.Document_No,
      this.Make_Code,
      this.Model_Code,
      this.Vehicle_Serial_No,
      this.Location_Code,
      this.No,
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
      Posting_Date: json['Posting_Date'],
      Document_No: json['Document_No'],
      Make_Code: json['Make_Code'],
      Model_Code: json['Model_Code'],
      Vehicle_Serial_No: json['Vehicle_Serial_No'],
      Location_Code: json['Location_Code'],
      No: json['No'],
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
