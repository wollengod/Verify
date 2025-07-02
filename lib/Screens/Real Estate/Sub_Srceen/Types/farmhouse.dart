import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify/custom_widget/back_button.dart';

import '../../../../model/Office_model.dart';

class FarmhousePropertyPage extends StatefulWidget {
  const FarmhousePropertyPage({super.key});

  @override
  State<FarmhousePropertyPage> createState() => _FarmhousePropertyPageState();
}

class _FarmhousePropertyPageState extends State<FarmhousePropertyPage> {
  late Future<List<OfficePropertyModel>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchOfficeProperties();
  }

  Future<List<OfficePropertyModel>> fetchOfficeProperties() async {
    final url = Uri.parse(
      "https://verifyserve.social/PHP_Files/showdata_for_farm/insert.php",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((item) => OfficePropertyModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load FarmHouse properties');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Farm House Properties",style: const TextStyle(fontSize: 20, fontFamily: 'Poppins'),
        ),
        leading: CustomBackButton(),
      ),
      body: FutureBuilder<List<OfficePropertyModel>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data;

          if (data == null || data.isEmpty) {
            return const Center(child: Text("No office properties found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Office Image
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        "https://verifyserve.social/${item.realstateImage}",
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 180,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    ),

                    // Details
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.address,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.place.isNotEmpty ? item.place : "Unknown Place",
                            style: TextStyle(
                              fontSize: 14,
                              color: textColor.withOpacity(0.7),
                            ),
                          ),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _iconText(Icons.meeting_room, item.typeOfProperty),
                              _iconText(Icons.elevator, item.floor),
                              _iconText(Icons.location_on, item.balcony),
                            ],
                          ),

                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rent: ₹${item.propertyNumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                item.furnished,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: item.furnished == "Unfurnished" ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).iconTheme.color),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
