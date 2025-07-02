class FilterModel {
  final int id;
  final String Realstate_image;
  final String Property_Number;
  final String Address_;
  final String Place_;
  final String Price;
  final String maintenance;
  final String Buy_Rent;
  final String Residence_Commercial;
  final String floor_;
  final String flat_;
  final String date_;
  final String Looking_Property_;
  final String Typeofproperty;
  final String Bhk_Squarefit;
  final String Furnished;
  final String Details;
  final String Ownername;
  final String Owner_number;
  final String fieldworkarname;
  final String fieldworkarnumber;
  final String Building_information;
  final String Parking;
  final String Lift;
  final String Security_guard;
  final String Goverment_meter;
  final String CCTV;
  final String District;
  final String Police_Station;
  final String Pin_Code;
  final String balcony;
  final String kitchen;
  final String Baathroom;
  final String Wifi;
  final String Waterfilter;
  final String Gas_meter;
  final String Water_geyser;
  final String Longtitude;
  final String Latitude;
  final String Address_apnehisaabka;
  final String CareTaker_number;

  FilterModel({
    required this.id,
    required this.Realstate_image,
    required this.Property_Number,
    required this.Address_,
    required this.Place_,
    required this.Price,
    required this.maintenance,
    required this.Buy_Rent,
    required this.Residence_Commercial,
    required this.floor_,
    required this.flat_,
    required this.date_,
    required this.Looking_Property_,
    required this.Typeofproperty,
    required this.Bhk_Squarefit,
    required this.Furnished,
    required this.Details,
    required this.Ownername,
    required this.Owner_number,
    required this.fieldworkarname,
    required this.fieldworkarnumber,
    required this.Building_information,
    required this.Parking,
    required this.Lift,
    required this.Security_guard,
    required this.Goverment_meter,
    required this.CCTV,
    required this.District,
    required this.Police_Station,
    required this.Pin_Code,
    required this.balcony,
    required this.kitchen,
    required this.Baathroom,
    required this.Wifi,
    required this.Waterfilter,
    required this.Gas_meter,
    required this.Water_geyser,
    required this.Longtitude,
    required this.Latitude,
    required this.Address_apnehisaabka,
    required this.CareTaker_number,
  });

  factory FilterModel.FromJson(Map<String, dynamic> json) {
    return FilterModel(
      id: int.tryParse(json['PVR_id'].toString()) ?? 0,
      Realstate_image: json['Realstate_image'] ?? '',
      Property_Number: json['Property_Number'] ?? '',
      Address_: json['Address_'] ?? '',
      Place_: json['Place_'] ?? '',
      Price: json['Price'] ?? '',
      maintenance: json['maintenance'] ?? '',
      Buy_Rent: json['Buy_Rent'] ?? '',
      Residence_Commercial: json['Residence_Commercial'] ?? '',
      floor_: json['floor_'] ?? '',
      flat_: json['flat_'] ?? '',
      date_: json['date_'] ?? '',
      Looking_Property_: json['Looking_Property_'] ?? '',
      Typeofproperty: json['Typeofproperty'] ?? '',
      Bhk_Squarefit: json['Bhk_Squarefit'] ?? '',
      Furnished: json['Furnished'] ?? '',
      Details: json['Details'] ?? '',
      Ownername: json['Ownername'] ?? '',
      Owner_number: json['Owner_number'] ?? '',
      fieldworkarname: json['fieldworkarname'] ?? '',
      fieldworkarnumber: json['fieldworkarnumber'] ?? '',
      Building_information: json['Building_information'] ?? '',
      Parking: json['Parking'] ?? '',
      Lift: json['Lift'] ?? '',
      Security_guard: json['Security_guard'] ?? '',
      Goverment_meter: json['Goverment_meter'] ?? '',
      CCTV: json['CCTV'] ?? '',
      District: json['District'] ?? '',
      Police_Station: json['Police_Station'] ?? '',
      Pin_Code: json['Pin_Code'] ?? '',
      balcony: json['balcony'] ?? '',
      kitchen: json['kitchen'] ?? '',
      Baathroom: json['Baathroom'] ?? '',
      Wifi: json['Wifi'] ?? '',
      Waterfilter: json['Waterfilter'] ?? '',
      Gas_meter: json['Gas_meter'] ?? '',
      Water_geyser: json['Water_geyser'] ?? '',
      Longtitude: json['Longtitude'] ?? '',
      Latitude: json['Latitude'] ?? '',
      Address_apnehisaabka: json['Address_apnehisaabka'] ?? '',
      CareTaker_number: json['CareTaker_number'] ?? '',
    );
  }
}
