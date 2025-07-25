import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/utilities/hex_color.dart';
import '../../../../custom_widget/property_card.dart';
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
      data.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id'])); //descending
      return data.map((item) => OfficePropertyModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load FarmHouse properties');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: "#E3EFFF".toColor(),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          FutureBuilder<List<OfficePropertyModel>>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return
                  Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Container(child:
                    Center(
                        child: CircularProgressIndicator(color: Colors.black)
                    )
                    ),
                  );
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}',style: TextStyle(color: Colors.black)));
              }

              final data = snapshot.data;

              if (data == null || data.isEmpty) {
                return const Center(child: Text("No Farmhouse properties found.",style: TextStyle(color: Colors.black),));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // Let the outer ListView handle scrolling
                scrollDirection: Axis.vertical,
                itemCount: data.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final item = data[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: PropertyCard(item: item),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

}
