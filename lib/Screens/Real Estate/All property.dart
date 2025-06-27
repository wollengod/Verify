import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/custom_widget/back_button.dart';
import '../../Themes/mode button.dart';
import '../../Themes/theme-helper.dart';
import '../../custom_widget/Paths.dart';
import '../../model/Home_model.dart';
import 'Sub_Srceen/PropertyBylist.dart';
import 'Sub_Srceen/full property.dart';

class AllProperty extends StatefulWidget {
  const AllProperty({super.key});

  @override
  State<AllProperty> createState() => _AllPropertyState();
}

class _AllPropertyState extends State<AllProperty> {
  String _number = '';
  Future<List<Catid>>? _futureData;
  List<Catid> allProperties = [];
  List<Catid> filteredProperties = [];
  bool isLoading = false;
  bool hasTyped = false;
  TextEditingController searchController = TextEditingController();


  final List<Map<String, dynamic>> propertyTypes = [
    {'label': 'House', 'icon': Icons.house, 'selected': false},
    {'label': 'Flat', 'icon': Icons.apartment, 'selected': false},
    {'label': 'Farmhouse', 'icon': Icons.cottage, 'selected': false},
    {'label': 'Office', 'icon': Icons.location_city, 'selected': false},
    {'label': 'Shop', 'icon': Icons.warehouse_outlined, 'selected': false},
    {'label': 'Apartment', 'icon': Icons.apartment_sharp, 'selected': false},
    {'label': 'Godown', 'icon': Icons.warehouse, 'selected': false},
  ];


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
      return data.map((item) => Catid.FromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
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
  void handleTap(int index) async { // click
    setState(() {
      propertyTypes[index]['selected'] = true;
    });

    await Future.delayed(Duration(milliseconds: 300)); // blue highlight for 0.3 sec

    setState(() {
      propertyTypes[index]['selected'] = false;
    });


    final selectedType = propertyTypes[index]['label'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
        //AllProperty(),
        PropertyListByType(type: selectedType),
      ),
    );
  }

  // void handleTap(int index) {  //hold
  //   setState(() {
  //     for (int i = 0; i < propertyTypes.length; i++) {
  //       propertyTypes[i]['selected'] = i == index;
  //     }
  //   });
  //
  //   print("Tapped: ${propertyTypes[index]['label']}");
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor(context),
          body:  _futureData == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Container(
                height: 80,
                width: double.infinity,
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const CustomBackButton(),
                    const SizedBox(width: 35),
                    Image.asset(AppImages.appbar, height: 100),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: searchController,
                  onChanged: _filterResults,
                  decoration: InputDecoration(
                    hintText: "Search by location or BHK...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: AppColors.bgColor(context),
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(propertyTypes.length, (index) {
                      final type = propertyTypes[index];
                      final isSelected = type['selected'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          onTap: () => handleTap(index),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 100,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue.shade50 : AppColors.bgColor(context),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isSelected
                                  ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ]
                                  : [],
                              border: Border.all(
                                color: isSelected ? Colors.blue : Colors.grey.shade500,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  type['icon'],
                                  color: isSelected ? Colors.blue : AppColors.textColor(context),
                                  size: 30,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  type['label'],
                                  style: TextStyle(
                                    color: isSelected ? Colors.blue : AppColors.textColor(context),
                                    fontFamily: 'Poppins',
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(15.0),
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
                    Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Catid>>(
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
                    return ListView.builder(
                      itemCount: data.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return propertyCard(item);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ));
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
          color: Theme.of(context).scaffoldBackgroundColor,
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
                        child:
                        Text(
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color,),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.Building_Location,
                          style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium!.color,),
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
                      featureIcon(Icons.square_foot, ""
                          "1000 Sqft"),
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
        Icon(icon, size: 16, color: Theme.of(context).textTheme.bodyMedium!.color,),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Theme.of(context).textTheme.bodyMedium!.color,)),
      ],
    );
  }
}
