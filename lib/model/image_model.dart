class RealEstateSlider {
  int? subid;
  String? image;

  RealEstateSlider({this.subid, this.image});

  RealEstateSlider.fromJson(Map<String, dynamic> json) {
    subid = json['subid'];
    image = json['M_images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['subid'] = subid;
    data['M_images'] = image;
    return data;
  }
}
