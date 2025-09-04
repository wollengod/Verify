class OfficePropertyModel {
  final String pvrId;
  final String realstateImage;
  final String propertyNumber;
  final String address;
  final String place;
  final String city;
  final String price;
  final String maintenance;
  final String buyRent;
  final String residenceCommercial;
  final String floor;
  final String flat;
  final String date;
  final String lookingProperty;
  final String typeOfProperty;
  final String bhkSquarefit;
  final String furnished;
  final String details;
  final String ownerName;
  final String ownerNumber;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String buildingInfo;
  final String parking;
  final String lift;
  final String securityGuard;
  final String governmentMeter;
  final String cctv;
  final String district;
  final String policeStation;
  final String pinCode;
  final String balcony;
  final String kitchen;
  final String bathroom;
  final String wifi;
  final String waterFilter;
  final String gasMeter;
  final String waterGeyser;
  final String longitude;
  final String latitude;
  final String addressApneHisaabKa;
  final String careTakerNumber;

  OfficePropertyModel({
    required this.pvrId,
    required this.realstateImage,
    required this.propertyNumber,
    required this.address,
    required this.place,
    required this.city,
    required this.price,
    required this.maintenance,
    required this.buyRent,
    required this.residenceCommercial,
    required this.floor,
    required this.flat,
    required this.date,
    required this.lookingProperty,
    required this.typeOfProperty,
    required this.bhkSquarefit,
    required this.furnished,
    required this.details,
    required this.ownerName,
    required this.ownerNumber,
    required this.fieldworkerName,
    required this.fieldworkerNumber,
    required this.buildingInfo,
    required this.parking,
    required this.lift,
    required this.securityGuard,
    required this.governmentMeter,
    required this.cctv,
    required this.district,
    required this.policeStation,
    required this.pinCode,
    required this.balcony,
    required this.kitchen,
    required this.bathroom,
    required this.wifi,
    required this.waterFilter,
    required this.gasMeter,
    required this.waterGeyser,
    required this.longitude,
    required this.latitude,
    required this.addressApneHisaabKa,
    required this.careTakerNumber,
  });

  factory OfficePropertyModel.fromJson(Map<String, dynamic> json) {
    return OfficePropertyModel(
      pvrId: json['PVR_id'] ?? '',
      realstateImage: json['Realstate_image'] ?? '',
      propertyNumber: json['Property_Number'] ?? '',
      address: json['Address_'] ?? '',
      place: json['Place_'] ?? '',
      city: json['City'] ?? '',
      price: json['Price'] ?? '',
      maintenance: json['maintenance'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      floor: json['floor_'] ?? '',
      flat: json['flat_'] ?? '',
      date: json['date_'] ?? '',
      lookingProperty: json['Looking_Property_'] ?? '',
      typeOfProperty: json['Typeofproperty'] ?? '',
      bhkSquarefit: json['Bhk_Squarefit'] ?? '',
      furnished: json['Furnished'] ?? '',
      details: json['Details'] ?? '',
      ownerName: json['Ownername'] ?? '',
      ownerNumber: json['Owner_number'] ?? '',
      fieldworkerName: json['fieldworkarname'] ?? '',
      fieldworkerNumber: json['fieldworkarnumber'] ?? '',
      buildingInfo: json['Building_information'] ?? '',
      parking: json['Parking'] ?? '',
      lift: json['Lift'] ?? '',
      securityGuard: json['Security_guard'] ?? '',
      governmentMeter: json['Goverment_meter'] ?? '',
      cctv: json['CCTV'] ?? '',
      district: json['District'] ?? '',
      policeStation: json['Police_Station'] ?? '',
      pinCode: json['Pin_Code'] ?? '',
      balcony: json['balcony'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['Baathroom'] ?? '',
      wifi: json['Wifi'] ?? '',
      waterFilter: json['Waterfilter'] ?? '',
      gasMeter: json['Gas_meter'] ?? '',
      waterGeyser: json['Water_geyser'] ?? '',
      longitude: json['Longtitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      addressApneHisaabKa: json['Address_apnehisaabka'] ?? '',
      careTakerNumber: json['CareTaker_number'] ?? '',
    );
  }
}
