class SearchModel {
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

  SearchModel({
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

  factory SearchModel.fromJson(Map<String, dynamic> json) {
    return SearchModel(
      pvrId: json['PVR_id']?.toString() ?? '',
      realstateImage: json['Realstate_image']?.toString() ?? '',
      propertyNumber: json['Property_Number']?.toString() ?? '',
      address: json['Address_']?.toString() ?? '',
      place: json['Place_']?.toString() ?? '',
      city: json['City']?.toString() ?? '',
      price: json['Price']?.toString() ?? '',
      maintenance: json['maintenance']?.toString() ?? '',
      buyRent: json['Buy_Rent']?.toString() ?? '',
      residenceCommercial: json['Residence_Commercial']?.toString() ?? '',
      floor: json['floor_']?.toString() ?? '',
      flat: json['flat_']?.toString() ?? '',
      date: json['date_']?.toString() ?? '',
      lookingProperty: json['Looking_Property_']?.toString() ?? '',
      typeOfProperty: json['Typeofproperty']?.toString() ?? '',
      bhkSquarefit: json['Bhk_Squarefit']?.toString() ?? '',
      furnished: json['Furnished']?.toString() ?? '',
      details: json['Details']?.toString() ?? '',
      ownerName: json['Ownername']?.toString() ?? '',
      ownerNumber: json['Owner_number']?.toString() ?? '',
      fieldworkerName: json['fieldworkarname']?.toString() ?? '',
      fieldworkerNumber: json['fieldworkarnumber']?.toString() ?? '',
      buildingInfo: json['Building_information']?.toString() ?? '',
      parking: json['Parking']?.toString() ?? '',
      lift: json['Lift']?.toString() ?? '',
      securityGuard: json['Security_guard']?.toString() ?? '',
      governmentMeter: json['Goverment_meter']?.toString() ?? '',
      cctv: json['CCTV']?.toString() ?? '',
      district: json['District']?.toString() ?? '',
      policeStation: json['Police_Station']?.toString() ?? '',
      pinCode: json['Pin_Code']?.toString() ?? '',
      balcony: json['balcony']?.toString() ?? '',
      kitchen: json['kitchen']?.toString() ?? '',
      bathroom: json['Baathroom']?.toString() ?? '',
      wifi: json['Wifi']?.toString() ?? '',
      waterFilter: json['Waterfilter']?.toString() ?? '',
      gasMeter: json['Gas_meter']?.toString() ?? '',
      waterGeyser: json['Water_geyser']?.toString() ?? '',
      longitude: json['Longtitude']?.toString() ?? '',
      latitude: json['Latitude']?.toString() ?? '',
      addressApneHisaabKa: json['Address_apnehisaabka']?.toString() ?? '',
      careTakerNumber: json['CareTaker_number']?.toString() ?? '',
    );
  }
}
