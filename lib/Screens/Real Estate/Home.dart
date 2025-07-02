import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/Screens/Real%20Estate/All%20property.dart';
import 'package:verify/Themes/theme-helper.dart';

import '../../custom_widget/Searchbar.dart';
import '../../model/Home_model.dart';
import '../Insurace/Health.dart';
import '../Insurace/Motor.dart';
import '../Services/Service_Page.dart';
import 'Sub_Srceen/full property.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Catid> allProperties = [];
  List<Catid> filteredProperties = [];
  bool isLoading = false;
  bool hasTyped = false;
  TextEditingController searchController = TextEditingController();

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

      // 👇 Only keep the latest 10 items
      return data.take(10).map((item) => Catid.FromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }


  // void _filterResults(String query) {
  //   setState(() {
  //     hasTyped = query.isNotEmpty;
  //     isLoading = true;
  //   });
  //
  //   final results = allProperties.where((item) {
  //     final name = item.Building_Location.toLowerCase();
  //     final bhk = item.BHK.toLowerCase();
  //     return name.contains(query.toLowerCase()) ||
  //         bhk.contains(query.toLowerCase());
  //   }).toList();
  //
  //   setState(() {
  //     filteredProperties = results;
  //     isLoading = false;
  //   });
  // }
    final List<Map<String, dynamic>> categories =  [
    {
      'title': 'Real Estate',
      'image': 'assets/Icons/house.png',
      'page': AllProperty(),
    },
    {
      'title': 'Services',
      'image': 'assets/Icons/mechanic.png',
      'page': ServicesPage(),
    },
    {
      'title': 'Insurance',
      'image': 'assets/Icons/cardiogram.png',
      'page': HealthPage(),
    },
    {
      'title': 'Vehicle Alert',
      'image': 'assets/Icons/car.png',
      'page': Motor(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    // final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    // final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor(context),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10,),
                Expanded(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final item = categories[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => item['page']),
                                  );
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: AppColors.bgColor(context),
                                        borderRadius: BorderRadius.circular(80),
                                        border: Border.all(color: Colors.grey.shade300),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(item['image'], height: 40, width: 40),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(6.0),
                                      child: Text(
                                        item['title'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textColor(context),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 5),
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
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Text(
                              //   "See all",
                              //   style: TextStyle(
                              //     fontSize: 15,
                              //     fontWeight: FontWeight.w400,
                              //     fontFamily: 'Poppins',
                              //     color: Theme.of(context).textTheme.bodyMedium!.color,
                              //   ),
                              // ),
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
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: GridView.builder(
                                itemCount: data.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 3.5 / 4,
                                ),
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return propertyGridCard(item);
                                },
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        )
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
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 2,
              offset: const Offset(2, 2),
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
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
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
                          color: AppColors.textColor(context),
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
                        style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 15, color: AppColors.textColor(context),),
                          const SizedBox(width: 4),
                          Text(
                            item.Building_Location,
                            style:  TextStyle(fontSize: 16, color: AppColors.textColor(context), ),
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
    );
  }

  // Widget propertyCard(Catid item) {
  //   return GestureDetector(
  //     onTap: () async {
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setInt('id_Building', item.id);
  //       prefs.setString('id_Longitude', item.Longitude);
  //       prefs.setString('id_Latitude', item.Latitude);
  //       Navigator.push(context, MaterialPageRoute(builder: (context)
  //       => Full_Property(),
  //       ));
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.only(bottom: 20),
  //       decoration: BoxDecoration(
  //         color: Theme.of(context).scaffoldBackgroundColor,
  //         borderRadius: BorderRadius.circular(16),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.15),
  //             blurRadius: 10,
  //             offset: const Offset(0, 5),
  //           ),
  //         ],
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Image
  //           ClipRRect(
  //             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
  //             child: Image.network(
  //               "https://verifyserve.social/${item.Building_image}",
  //               height: 200,
  //               width: double.infinity,
  //               fit: BoxFit.cover,
  //               errorBuilder: (context, error, stackTrace) => Container(
  //                 height: 200,
  //                 color: Colors.grey.shade200,
  //                 child: const Icon(Icons.image_not_supported, size: 40),
  //               ),
  //             ),
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Title + Price
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Expanded(
  //                       child:
  //                       Text(
  //                         item.buy_Rent,
  //                         style: const TextStyle(
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w600,
  //                           fontFamily: 'Poppins',
  //                         ),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                     Text(
  //                       "₹${item.Rent + item.Verify_price}",
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold,
  //                         fontFamily: 'Poppins',
  //                         color: Theme.of(context).textTheme.bodyMedium!.color,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 6),
  //
  //                 // Location
  //                 Row(
  //                   children: [
  //                     Icon(Icons.location_on, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color,),
  //                     const SizedBox(width: 4),
  //                     Expanded(
  //                       child: Text(
  //                         item.Building_Location,
  //                         style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium!.color,),
  //                         overflow: TextOverflow.ellipsis,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 10),
  //
  //                 // Features Row
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     featureIcon(Icons.bed, "${item.BHK}"),
  //                     featureIcon(Icons.bathtub_outlined, "${item.Baathroom} Baths"),
  //                     featureIcon(Icons.square_foot, ""
  //                         "1000 Sqft"),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 10),
  //
  //                 // Rating + Distance (Static)
  //                 Row(
  //                   children: [
  //                     const Icon(Icons.star, color: Colors.amber, size: 16),
  //                     const SizedBox(width: 4),
  //                     const Text("4.8 (112)", style: TextStyle(fontSize: 13)),
  //                     const SizedBox(width: 12),
  //                     const Icon(Icons.directions_walk, size: 16, color: Colors.black54),
  //                     const SizedBox(width: 4),
  //                     const Text("780m (12 min)", style: TextStyle(fontSize: 13)),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget featureIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color,),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium!.color,)),
      ],
    );
  }
}
