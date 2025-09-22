class ServiceModel {
  final String id;
  final String name;
  final String image;

  ServiceModel({required this.id, required this.name, required this.image});

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['s_name'],
      image: json['s_img'],
    );
  }
}
