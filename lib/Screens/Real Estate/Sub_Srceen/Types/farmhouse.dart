import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../model/Office_model.dart';
import '../full property.dart';

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
    final url = Uri.parse("https://verifyserve.social/PHP_Files/showdata_for_farm/insert.php");
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
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          FutureBuilder<List<OfficePropertyModel>>(
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
                return const Center(child: Text("No Farmhouse properties found."));
              }

              return SizedBox(
                height: screenHeight * 0.45,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: _buildFarmCard(item),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }

  Widget _buildFarmCard(OfficePropertyModel item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', int.parse(item.pvrId));
        prefs.setString('id_Longitude', item.longitude);
        prefs.setString('id_Latitude', item.latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
      },
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                "https://verifyserve.social/${item.realstateImage}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.place.isNotEmpty ? item.place : "Unknown Place",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rent: ₹${item.propertyNumber}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        item.furnished,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
