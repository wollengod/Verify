class AllModel {
  final String id;
  final String Building_Name;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Rent;
  final String Verify_price;
  final String BHK;
  final String sqft;
  final String tyope;
  final String floor_;
  final String maintence;
  final String buy_Rent;
  final String Building_information;
  final String Parking;
  final String balcony;
  final String facility;
  final String Furnished;
  final String kitchen;
  final String Baathroom;
  final String Date;
  final String Ownername;

  AllModel({
    required this.id,
    required this.Building_Name,
    required this.Building_Address,
    required this.Building_Location,
    required this.Building_image,
    required this.Longitude,
    required this.Latitude,
    required this.Rent,
    required this.Verify_price,
    required this.BHK,
    required this.sqft,
    required this.tyope,
    required this.floor_,
    required this.maintence,
    required this.buy_Rent,
    required this.Building_information,
    required this.balcony,
    required this.Parking,
    required this.facility,
    required this.Furnished,
    required this.kitchen,
    required this.Baathroom,
    required this.Date,
    required this.Ownername,
  });

  factory AllModel.FromJson(Map<String, dynamic> json) {
    return AllModel(
      id: json['PVR_id'] ?? 0,
      Building_Name: json['Building_information'] ?? '',
      Building_Address: json['Address_'] ?? '',
      Building_Location: json['Place_'] ?? '',
      Building_image: json['Realstate_image'] ?? '',
      Longitude: json['Longtitude'] ?? '',
      Latitude: json['Latitude'] ?? '',
      Rent: json['Property_Number'] ?? '',
      Verify_price: json['Price'] ?? '',
      BHK: json['Bhk_Squarefit'] ?? '',
      sqft: json['City'] ?? '',
      tyope: json['Typeofproperty'] ?? '',
      floor_: json['floor_'] ?? '',
      maintence: json['maintenance'] ?? '',
      buy_Rent: json['Buy_Rent'] ?? '',
      Building_information: json['Building_information'] ?? '',
      balcony: json['balcony'] ?? '',
      Parking: json['Parking'] ?? '',
      facility: json['Lift'] ?? '',
      Furnished: json['Furnished'] ?? '',
      kitchen: json['kitchen'] ?? '',
      Baathroom: json['Baathroom'] ?? '',
      Date: json['date_'] ?? '',
      Ownername: json['Ownername'] ?? '',
    );
  }
}
