import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/utilities/hex_color.dart';
import '../../../custom_widget/Paths.dart';
import '../../../custom_widget/Preview.dart';
import '../../../custom_widget/back_button.dart';
import '../../../model/Home_model.dart';
import '../../../model/image_model.dart';

class Full_Property extends StatefulWidget {
  const Full_Property({super.key});

  @override
  State<Full_Property> createState() => _Full_PropertyState();
}

class _Full_PropertyState extends State<Full_Property> {
  late Future<List<Catid>> _propertyFuture;
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

  Future<List<Catid>> fetchProperty(String? id) async {
    final response = await http.get(Uri.parse(
        "https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=$id"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Catid.FromJson(e)).toList();
    } else {
      throw Exception('Failed to load property');
    }
  }

  Future<List<RealEstateSlider>> fetchSlider(String? id) async {
    final response = await http.get(Uri.parse(
        "https://verifyserve.social/WebService4.asmx/Show_Image_under_Realestatet?id_num=$id"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => RealEstateSlider.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load images');
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
      ),
      body: SafeArea(
        child: FutureBuilder<List<Catid>>(
          future: _propertyFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.first;

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      FutureBuilder<List<RealEstateSlider>>(
                        future: _sliderFuture,
                        builder: (context, sliderSnap) {
                          return buildImageCarousel(data, sliderSnap.data ?? []);
                        },
                      ),
                      const SizedBox(height: 5),
                      buildTitleLocation(data),
                      const SizedBox(height: 10),
                      buildChips(data),
                      const SizedBox(height: 20),
                      buildDetailsGrid(data),
                      const SizedBox(height: 20),
                      buildStaticInfoSection(),
                      const SizedBox(height: 20),
                      Text("Description",
                          style: GoogleFonts.poppins(color: Colors.black,
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      const Divider(color: Colors.black),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.Building_information,
                          style:
                          GoogleFonts.poppins(fontSize: 15, color: Colors.black87),
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
      bottomNavigationBar: FutureBuilder<List<Catid>>(
          future: _propertyFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            final data = snapshot.data!.first;
            return Material(
              elevation: 10,
              color: "#EEF5FF".toColor(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹ ${data.Rent + data.Verify_price}',
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            color: "#001234".toColor(),
                            fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      onPressed: () {
                        // Add your booking logic here
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

  Widget buildImageCarousel(Catid data, List<RealEstateSlider> sliders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Hero(
          tag: 'property-image-${data.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              'https://verifyserve.social/${data.Building_image}',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: sliders.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final img = sliders[index].rimg!;
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImagePreviewScreen(
                      imageUrls: sliders.map((e) => e.rimg!).toList(),
                      initialIndex: index,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://verifyserve.social/$img',
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

  Widget buildStaticInfoSection() {
    final List<Map<String, dynamic>> infoList = [
      {
        'icon': Icons.double_arrow_outlined,
        'title': 'Facing',
        'value': 'East',
      },
      {
        'icon': Icons.home_work_outlined,
        'title': 'Property Age',
        'value': '5-10 Years',
      },
      {
        'icon': Icons.stairs,
        'title': 'Total Floors',
        'value': '4',
      },
      {
        'icon': Icons.store_mall_directory,
        'title': 'On Floor',
        'value': '2nd',
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


  Widget buildTitleLocation(Catid data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("${data.BHK} ${data.tyope} in ",
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w400,color: Colors.black87)),
            Text(data.Building_Location,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600,
                    fontSize: 20, color: Colors.blue.shade900)),
          ],
        ),
      ],
    );
  }

  Widget buildChips(Catid data) {
    return Wrap(
      spacing: 10,
      children: [
        chip(Icons.check_circle, data.Furnished),
        chip(Icons.balcony, data.balcony),
        chip(Icons.local_parking, data.Parking),
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

  Widget buildDetailsGrid(Catid data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        statTile(Icons.bed, data.BHK, 'Bed'),
        statTile(Icons.bathtub, data.Baathroom, 'Bath'),
        statTile(Icons.house, data.tyope, 'Property'),
        statTile(Icons.square_foot, '900', 'Sqft'),
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
