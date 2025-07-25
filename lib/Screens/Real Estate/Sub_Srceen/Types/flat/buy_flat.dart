import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../../model/Office_model.dart';
import '../../../../../model/buy_flat_card.dart';

class FlatPropertyBuy extends StatefulWidget {
  const FlatPropertyBuy({super.key});

  @override
  State<FlatPropertyBuy> createState() => _FlatPropertyBuyState();
}

class _FlatPropertyBuyState extends State<FlatPropertyBuy> {
  late Future<List<OfficePropertyModel>> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = fetchOfficeProperties();
  }

  Future<List<OfficePropertyModel>> fetchOfficeProperties() async {
    final url = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/show_data_sale_property/show_data_for_sale_property.php");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      data.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id'])); //descending
      return data.map((item) => OfficePropertyModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load buy flat properties');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OfficePropertyModel>>(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return
            Padding(
              padding: const EdgeInsets.only(top: 100),
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
          return const Center(child: Text("No Buy Flat properties found.",style: TextStyle(color: Colors.black)));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: BuyFlatCard(item: data[index]),
            );
          },
        );
      },
    );
  }
}
