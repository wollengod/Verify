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
import 'Sub_Srceen/PropertyBylist.dart';
import 'Sub_Srceen/Types/Flat.dart';
import 'Sub_Srceen/Types/Godown.dart';
import 'Sub_Srceen/Types/Office.dart';
import 'Sub_Srceen/Types/farmhouse.dart';
import 'Sub_Srceen/Types/feat_property.dart';
import 'Sub_Srceen/Types/shop.dart';
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
  String selectedType = 'Featured';
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> propertyTypes = [
    {'label': 'Featured', 'icon': Icons.notification_important_sharp, 'selected': false},
    {'label': 'Flat', 'icon': Icons.apartment, 'selected': false},
    {'label': 'Farmhouse', 'icon': Icons.cottage, 'selected': false},
    {'label': 'Office', 'icon': Icons.location_city, 'selected': false},
    {'label': 'Shop', 'icon': Icons.storefront_outlined, 'selected': false},
    {'label': 'Godown', 'icon': Icons.warehouse, 'selected': false},
  ];

  String _number = '';
  Future<List<Catid>>? _futureData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  void handleTap(int index) {
    setState(() {
      for (var i = 0; i < propertyTypes.length; i++) {
        propertyTypes[i]['selected'] = i == index;
      }
      selectedType = propertyTypes[index]['label'];
    });
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
    // {
    //   'title': 'Real Estate',
    //   'image': 'assets/Icons/house.png',
    //   'page': AllProperty(),
    // },
    {
      'title': 'Services',
      'image': 'assets/Icons/mechanic.png',
      'page': ServicePage(),
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
    return DefaultTabController(
      length: propertyTypes.length,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // 🔵 Top Section
              ClipPath(
                clipper: BottomLeftCurveClipper(),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.blue.shade900,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: NeumorphicSearchBar(HintText: 'Search Here'),
                      ),
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
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.all(6.0),
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: AppColors.bgColor(context),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(item['image'], height: 40, width: 40),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.all(6.0),
                                      child: Text(
                                        item['title'],
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              PreferredSize(
                preferredSize: Size.fromHeight(48),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: Colors.blue.shade800,
                    indicatorWeight: 3,
                    labelColor: Colors.blue.shade800,
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.only(right: 40),
                    tabs: propertyTypes.map((item) {
                      return Tab(
                        icon: Icon(item['icon'], size: 18),
                        text: item['label'],
                      );
                    }).toList(),
                    onTap: (index) {
                      setState(() {
                        selectedType = propertyTypes[index]['label'];
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10,),

              Expanded(
                child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: propertyTypes.map((item) {
                    final label = item['label'];
                    switch (label) {
                      case 'Featured':
                        return const FeatProperty();
                      case 'Flat':
                        return const FlatPropertyPage();
                      case 'Godown':
                        return const GodownPropertyPage();
                      case 'Shop':
                        return const ShopPropertyPage();
                      case 'Farmhouse':
                        return const FarmhousePropertyPage();
                      case 'Office':
                        return const OfficePropertyPage();
                      default:
                        return PropertyListByType(type: label);
                    }
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget featureIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16,color: Colors.black,
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 14,color: Colors.black,
        )),
      ],
    );
  }
}
class BottomLeftCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(0, size.height, 50, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
