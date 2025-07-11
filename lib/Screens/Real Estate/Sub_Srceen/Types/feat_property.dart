import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../model/Home_model.dart';
import '../full property.dart';

class FeatProperty extends StatefulWidget {
  const FeatProperty({super.key});

  @override
  State<FeatProperty> createState() => _FeatPropertyState();
}

class _FeatPropertyState extends State<FeatProperty> {
  String _number = '';
  Future<List<Catid>>? _futureData;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String number = prefs.getString('number') ?? '';
    setState(() {
      _number = number;
      _futureData = fetchData();
    });
  }
  Future<List<Catid>> fetchData() async {
    final url = Uri.parse(
      "https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=9711775300&looking=Flat",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      data.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));

      return data.take(10).map((item) => Catid.FromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body:  ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            margin: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Featured Property",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: Colors.black,

                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Catid>>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No Data Found!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              return SizedBox(
                height: 220, // Adjust height based on your card design
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 280,
                        height: 120,
                        child: propertyGridCard(item),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Sell Property",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: Colors.black,

                  ),
                ),
              ],
            ),
          ),

          FutureBuilder<List<Catid>>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No Data Found!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              return SizedBox(
                height: 200, // Adjust height based on your card design
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 250,
                        height: 150,// Adjust width of each card
                        child: propertyCard2(item),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Container(
            margin: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Rent Property",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  "See all",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: Colors.black,

                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Catid>>(
            future: _futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    "No Data Found!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }

              final data = snapshot.data!;
              return SizedBox(
                height: 200, // Adjust height based on your card design
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 250,
                        height: 120,// Adjust width of each card
                        child: propertyCard2(item),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 100,),
        ],
      ),
    );
  }

  Widget propertyGridCard(Catid item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', item.id);
        prefs.setString('id_Longitude', item.Longitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
      },
      child: Card(

        color: Colors.white,
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2,
                offset: const Offset(2, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  "https://verifyserve.social/${item.Building_image}",
                  height: 149,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 149,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.buy_Rent,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "₹${item.Rent + item.Verify_price}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item.BHK}",
                          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins',color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 15,color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.Building_Location,
                              style:  TextStyle(fontSize: 16,color: Colors.black,),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget propertyCard2(Catid item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', item.id);
        prefs.setString('id_Longitude', item.Longitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  "https://verifyserve.social/${item.Building_image}",
                  height: 135,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported, size: 30),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.buy_Rent,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "₹${item.Rent + item.Verify_price}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${item.BHK}",
                          style: const TextStyle(fontSize: 13, fontFamily: 'Poppins',color: Colors.black,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 15,color: Colors.black,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.Building_Location,
                              style:  TextStyle(fontSize: 16,color: Colors.black,),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
