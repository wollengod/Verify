import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/Home_model.dart';
import 'full property.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Catid> allProperties = [];
  List<Catid> filteredProperties = [];
  bool isLoading = false;
  bool hasTyped = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=9711775300&looking=Flat");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      final List<Catid> properties =
      data.map((json) => Catid.FromJson(json)).toList();

      setState(() {
        allProperties = properties;
      });
    } else {
      throw Exception('Failed to fetch properties');
    }
  }

  void _filterResults(String query) {
    setState(() {
      hasTyped = query.isNotEmpty;
      isLoading = true;
    });

    final results = allProperties.where((item) {
      final name = item.Building_Location.toLowerCase();
      final bhk = item.BHK.toLowerCase();
      return name.contains(query.toLowerCase()) ||
          bhk.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredProperties = results;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(child: Text("Support Page"),),
      // backgroundColor: Colors.white,
      // body: Column(
      //   children: [
      //     // Search Bar
      //     SizedBox(height: 20,),
      //     Padding(
      //       padding: const EdgeInsets.all(16),
      //       child: TextField(
      //         controller: searchController,
      //         onChanged: _filterResults,
      //         decoration: InputDecoration(
      //           hintText: "Search by location or BHK...",
      //           prefixIcon: const Icon(Icons.search),
      //           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      //           filled: true,
      //           fillColor: Colors.grey[100],
      //         ),
      //       ),
      //     ),
      //
      //     // Results
      //     Expanded(
      //       child: !hasTyped
      //           ? Center(
      //         child: Text(
      //           "🔍 Search by name, BHK, or location...",
      //           style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
      //         ),
      //       )
      //           : isLoading
      //           ? const Center(child: CircularProgressIndicator())
      //           : filteredProperties.isEmpty
      //           ? const Center(child: Text("No results found"))
      //           : ListView.builder(
      //         itemCount: filteredProperties.length,
      //         padding: const EdgeInsets.symmetric(horizontal: 16),
      //         itemBuilder: (context, index) {
      //           final item = filteredProperties[index];
      //           return propertyCard(item);
      //         },
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget propertyCard(Catid item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', item.id);
        prefs.setString('id_Longitude', item.Longitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context)
        => Full_Property(),
        ));
        },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                "https://verifyserve.social/${item.Building_image}",
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.buy_Rent,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "₹${item.Rent + item.Verify_price}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Colors.brown,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.Building_Location,
                          style: const TextStyle(fontSize: 14, color: Colors.black54),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Features Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      featureIcon(Icons.bed, "${item.BHK}"),
                      featureIcon(Icons.bathtub_outlined, "${item.Baathroom} Baths"),
                      featureIcon(Icons.square_foot, "${item.sqft} Sqft"),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Rating + Distance (Static)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text("4.8 (112)", style: TextStyle(fontSize: 13)),
                      const SizedBox(width: 12),
                      const Icon(Icons.directions_walk, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      const Text("780m (12 min)", style: TextStyle(fontSize: 13)),
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
  Widget featureIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  Widget iconLabel(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
