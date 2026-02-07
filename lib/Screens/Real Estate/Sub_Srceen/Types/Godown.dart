import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Verify/utilities/hex_color.dart';
import '../../../../custom_widget/property_card.dart';
import '../../../../model/Office_model.dart';

class GodownPropertyPage extends StatefulWidget {
  const GodownPropertyPage({super.key});

  @override
  State<GodownPropertyPage> createState() => _GodownPropertyPageState();
}

class _GodownPropertyPageState extends State<GodownPropertyPage> {
  late Future<List<OfficePropertyModel>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchOfficeProperties();
  }

  Future<List<OfficePropertyModel>> fetchOfficeProperties() async {
    final userId = await getUserId();

    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/Godown.php?user_id=$userId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      // ✅ GODOWN API RETURNS LIST DIRECTLY
      final List<dynamic> data = decoded is List ? decoded : [];

      // sort descending by P_id
      data.sort((a, b) =>
          int.parse(b['P_id']).compareTo(int.parse(a['P_id'])));

      return data
          .map((e) => OfficePropertyModel.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load godown properties');
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
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final data = snapshot.data;

              if (data == null || data.isEmpty) {
                return const Center(
                    child: Column(
                  children: [
                    SizedBox(height: 100,),
                    Text("No Godown properties found.",style: TextStyle(color: Colors.black)),
                  ],
                )
                );
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
