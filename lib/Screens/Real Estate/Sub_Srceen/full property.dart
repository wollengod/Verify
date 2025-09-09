import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/Themes/theme-helper.dart';
import 'package:verify/utilities/hex_color.dart';
import '../../../custom_widget/Paths.dart';
import '../../../custom_widget/Preview.dart';
import '../../../custom_widget/back_button.dart';
import '../../../model/detailed_property_model.dart';
import '../../../model/image_model.dart';

class Full_Property extends StatefulWidget {
  const Full_Property({super.key});

  @override
  State<Full_Property> createState() => _Full_PropertyState();
}

class _Full_PropertyState extends State<Full_Property> {
  Future<List<DetailedPropertyModel>>_propertyFuture = Future.value([]);
  late Future<List<RealEstateSlider>> _sliderFuture;

  @override
  void initState() {
    super.initState();
    _loadAllData();

  }

  Future<void> _loadAllData() async {
    final id = await getPropertyID();
    setState(() {
      _propertyFuture = fetchProperty(id);
      _sliderFuture = fetchSlider(id);
    });
  }

  Future<String?> getPropertyID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_Building')?.toString();
  }

  Future<List<DetailedPropertyModel>> fetchProperty(String? id) async {
    final response = await http.get(Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/details_page.php?P_id=$id"));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded['success'] == true) {
        final data = decoded['data'];
        if (data is List) {
          return data
              .map<DetailedPropertyModel>((e) => DetailedPropertyModel.fromJson(e))
              .toList();
        } else {
          throw Exception("Unexpected 'data' format: ${data.runtimeType}");
        }
      } else {
        throw Exception("API returned failure or invalid format");
      }
    } else {
      throw Exception('Failed to load property');
    }
  }

  Future<List<RealEstateSlider>> fetchSlider(String? id) async {
    final response = await http.get(Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate_for_website/show_multiple_image_in_main_realestate.php?subid=$id"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        final List data = jsonResponse['data'];
        return data.map((e) => RealEstateSlider.fromJson(e)).toList();
      } else {
        throw Exception('API returned success = false');
      }
    } else {
      throw Exception('Failed to load images');
    }
  }

  final bookingDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());


  Future<void> bookSchedule({
    required String id,
    required String location,
    required String info,
    required String furnished,
    required String bhk,
    required String type,
    required String userId,
    required String userName,
    required String phoneNumber,
    required String address, // user’s address or property address
  }) async {
    final url = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/book_shedual/book_shedual.php');

    final body = {
      'user_ids': userId,
      'user_names': userName,
      'property_id': id,
      'locations': location,
      'booking_date': bookingDate,
      'descriptions': info,
      'furnished': furnished,
      'addresss': address,
      'BHK': bhk,
      'type_of_property': type,
      'phone_number': phoneNumber,
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200 && response.body.contains('success')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Successful')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking Failed: ${response.body}')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      //"#EEF5FF".toColor(),
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Image.asset(AppImages.logo2, height: 70),
        centerTitle: true,
        backgroundColor: "#001234".toColor(),
        surfaceTintColor: "#001234".toColor(),

      ),
      body: SafeArea(
        child: FutureBuilder<List<DetailedPropertyModel>>(
          future: _propertyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Row(
                children: [
                  Text("Error: ${snapshot.error}",style: TextStyle(color: AppColors.bgColor(context),fontSize: 13),),
                ],
              ));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No property data found"));
            }

            final data = snapshot.data!.first; // safe now

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [

                      Hero(
                        tag: 'property-image-${data.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data.propertyPhoto}',
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      FutureBuilder<List<RealEstateSlider>>(
                        future: _sliderFuture,
                        builder: (context, sliderSnap) {
                          if (sliderSnap.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (sliderSnap.hasError) {
                            return Center(child: Text("Error loading images"));
                          }
                          final slider_data = sliderSnap.data!.first; // safe now
                          return buildImageCarousel(slider_data, sliderSnap.data ?? []);
                        },
                      ),
                      const SizedBox(height: 5),
                      buildTitleLocation(data),
                      const SizedBox(height: 10),
                      buildChips(data),
                      const SizedBox(height: 20),
                      buildDetailsGrid(data),
                      const SizedBox(height: 20),
                      buildStaticInfoSection(data.floor,data.ageOfProperty,data.totalFloor,"${data.location} Metro"),
                      const SizedBox(height: 20),
                      Text(
                        "Available Facilities",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Divider(color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.facility,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const Divider(color: Colors.black),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: FutureBuilder<List<DetailedPropertyModel>>(
          future: _propertyFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const SizedBox(); // nothing to show
            }
            final data = snapshot.data!.first;
            return Material(
              elevation: 10,
              color: "#EEF5FF".toColor(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹ ${data.showPrice}',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: "#001234".toColor(),
                            fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () async {
                        final propertyList = await _propertyFuture;
                        final sliderList = await _sliderFuture;

                        if (propertyList.isEmpty) return;
                        final property = propertyList.first;

                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getInt("id") ?? "0";
                        final name = prefs.getString("name") ?? "0";
                        final number = prefs.getString("number") ?? "0";


                        await bookSchedule(
                          userId: userId.toString(),
                          userName: name,
                          phoneNumber: number,
                          address: data.apartmentAddress,
                          id: data.id.toString(),
                          location: data.location,
                          info: data.facility,
                          furnished: data.furnished,
                          bhk: data.bhk,
                          type: data.typeOfProperty,
                        );

                      },
  
                      style: ElevatedButton.styleFrom(
                        backgroundColor: "#001234".toColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        "Book Schedule",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white, // Changed from grey to white for better contrast
                        ),
                      ),
                    )

                    // ElevatedButton(
                    //   onPressed: data.Rent.isNotEmpty ? () {} : null,
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: "#001234".toColor(),
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(40)),
                    //   ),
                    //   child: Text(data.Rent.isNotEmpty ? "Book Schedule" : "Unavailable",
                    //       style: GoogleFonts.poppins(
                    //           fontWeight: FontWeight.w500, color: Colors.grey)),
                    // )
                  ],
                ),
              ),
            );

          }),
    );
  }

  Widget buildImageCarousel(RealEstateSlider data, List<RealEstateSlider> sliders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sliders.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final img = sliders[index].image!;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImagePreviewScreen(
                      imageUrls: sliders.map((e) => e.image!).toList(),
                      initialIndex: index,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/$img',
                    width: 80,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:[
            Text(
              "Total Images: ${sliders.length}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildStaticInfoSection(String floor,String Age,String total_floor,metro) {
    final List<Map<String, dynamic>> infoList = [
      {
        'icon': Icons.train,
        'title': 'Nearest Metro',
        'value': metro,
      },
      {
        'icon': Icons.home_work_outlined,
        'title': 'Property Age',
        'value': Age,
      },
      {
        'icon': Icons.stairs,
        'title': 'Total Floors',
        'value': total_floor,
      },
      {
        'icon': Icons.store_mall_directory,
        'title': 'On Floor',
        'value': floor,
      },
      {
        'icon': Icons.lightbulb_outline,
        'title': 'Electricity Status',
        'value': '24x7',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Additional Information",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ...infoList.map((item) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Row(
            children: [
              Icon(item['icon'], color: "#001234".toColor(), size: 20),
              const SizedBox(width: 10),
              Text(
                "${item['title']}: ",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: Colors.black,
                ),
              ),
              Expanded(
                child: Text(
                  item['value'],
                  style: GoogleFonts.poppins(color: Colors.black87),
                ),
              )
            ],
          ),
        )),
      ],
    );
  }


  Widget buildTitleLocation(DetailedPropertyModel data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5,),
        Row(
          children: [
            Text("${data.bhk} ${data.typeOfProperty} For ${data.buyRent} in ",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w400,color: Colors.black87)),
          ],
        ),
        SizedBox(height: 2,),
        Text(data.location,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600,
                fontSize: 20, color: Colors.blue.shade900)),
      ],
    );
  }

  Widget buildChips(DetailedPropertyModel data) {
    return Wrap(
      spacing: 10,
      children: [
        chip(Icons.check_circle, data.furnished),
        chip(Icons.balcony, data.balcony),
        chip(Icons.local_parking, data.parking),
        chip(Icons.account_balance_wallet, 'Budget friendly'),
      ],
    );
  }

  Widget chip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.black54),
      label: Text(label, style: GoogleFonts.poppins(color: Colors.black)),
      backgroundColor: "#E3EFFF".toColor(),
      shape: const StadiumBorder(side: BorderSide(color: Colors.black12)),
    );
  }

  Widget buildDetailsGrid(DetailedPropertyModel data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        statTile(Icons.bed, data.bhk, 'Bed'),
        statTile(Icons.bathtub, data.bathroom, 'Bath'),
        statTile(Icons.house, data.residenceCommercial, 'Property'),
        statTile(Icons.flip_to_front_outlined, data.squarefit, 'Sqft'),
      ],
    );
  }

  Widget statTile(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, fontSize: 14,color: Colors.black)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }
}
