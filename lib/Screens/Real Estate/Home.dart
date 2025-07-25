import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/utilities/hex_color.dart';
import '../../custom_widget/Searchbar.dart';
import '../../model/Home_model.dart';
import '../Insurace/Health.dart';
import '../Insurace/Motor.dart';
import '../Services/Service_Page.dart';
import 'Sub_Srceen/PropertyBylist.dart';
import 'Sub_Srceen/Types/Godown.dart';
import 'Sub_Srceen/Types/Office.dart';
import 'Sub_Srceen/Types/farmhouse.dart';
import 'Sub_Srceen/Types/flat/flat tab.dart';
import 'Sub_Srceen/Types/shop.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  String selectedType = 'Flat';
  String _number = '';
  Future<List<Catid>>? _futureData;
  late TabController _tabController;

  List<Map<String, dynamic>> propertyTypes = [
    {'label': 'Flat', 'icon': Icons.apartment},
    {'label': 'Farmhouse', 'icon': Icons.cottage},
    {'label': 'Office', 'icon': Icons.location_city},
    {'label': 'Shop', 'icon': Icons.storefront_outlined},
    {'label': 'Godown', 'icon': Icons.warehouse},
  ];

  final List<Map<String, dynamic>> categories = [
    {'title': 'Services', 'image': 'assets/Icons/mechanic.png', 'page': ServicePage()},
    {'title': 'Insurance', 'image': 'assets/Icons/cardiogram.png', 'page': HealthPage()},
    {'title': 'Vehicle Alert', 'image': 'assets/Icons/car.png', 'page': Motor()},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: propertyTypes.length, vsync: this);
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

  Future<void> _onRefresh() async {
    setState(() {
      _futureData = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: propertyTypes.length,
        child: Scaffold(
          backgroundColor: "#EEF5FF".toColor(),
          body: NestedScrollView(
            physics: const BouncingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: ClipPath(
                  clipper: BottomLeftCurveClipper(),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: "#001234".toColor(),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: NeumorphicSearchBar(HintText: 'Search Here'),
                        ),
                        SizedBox(
                          height: 120,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(6.0),
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: "#E3EFFF".toColor(),
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
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: "#E3EFFF".toColor(),
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
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    indicatorColor: Colors.blue.shade800,
                    indicatorWeight: 3,
                    labelColor: Colors.blue.shade800,
                    unselectedLabelColor: Colors.black,
                    labelStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                    padding: const EdgeInsets.only(left: 30),
                    labelPadding: const EdgeInsets.only(right: 40),
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
            ],
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: propertyTypes.map((item) {
                  final label = item['label'];
                  switch (label) {
                    case 'Flat':
                      return const FlatPropertyTabs();
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
          ),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);
  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.grey.shade100,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) => false;
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
