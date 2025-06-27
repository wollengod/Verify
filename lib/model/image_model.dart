class RealEstateSlider {
  int? id;
  String? rimg;
  int? pid;

  RealEstateSlider({this.id, this.rimg, this.pid});

  RealEstateSlider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rimg = json['imagepath'];
    pid = json['imagename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imagepath'] = this.rimg;
    data['imagename'] = this.pid;
    return data;
  }
}