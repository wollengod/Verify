import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Verify/custom_widget/back_button.dart';
import '../../custom_widget/property_card.dart';
import '../../custom_widget/search_card.dart';
import '../../model/filter_model.dart';
import '../../model/search_model.dart';
import 'Sub_Srceen/full property.dart';

class SearchResultPage extends StatefulWidget {
  final String keyword;

  const SearchResultPage({super.key, required this.keyword});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late Future<List<FilterPropertyModel>> _futureData;
  int totalResults = 0;

  @override
  void initState() {
    super.initState();
    _futureData = fetchSearchResults(widget.keyword);
  }

  Future<List<FilterPropertyModel>> fetchSearchResults(String keyword) async {
    final query = keyword.trim().replaceAll(" ", "%20");

    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/search_api_for_main_application.php",
    ).replace(queryParameters: {
      "search": keyword.trim(),
    });

    final response = await http.get(url); // ✅ changed to GET

    print("Response: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      // ✅ FIXED: status is now bool
      if (jsonData['status'] == true) {
        totalResults = jsonData['total_records'] ?? 0;
        final List rawList = jsonData['data'];

        return rawList
            .map((e) => FilterPropertyModel.fromJson(e))
            .toList();
      } else {
        throw Exception("No data found");
      }
    } else {
      throw Exception("Server error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search Results",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              widget.keyword,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),        backgroundColor: Colors.blue.shade900,
        leading: CustomBackButton(),
      ),
      body: FutureBuilder<List<FilterPropertyModel>>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No results found",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Try different keywords",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      "${totalResults > 0 ? totalResults : data.length} properties found",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SearchPropertyCard(item: item),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

}
