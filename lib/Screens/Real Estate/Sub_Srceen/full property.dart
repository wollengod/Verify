import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    _propertyFuture = fetchProperty();
    _sliderFuture = fetchSlider();
  }

  Future<String?> getPropertyID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id_Building')?.toString();
  }

  Future<List<Catid>> fetchProperty() async {
    final id = await getPropertyID();
    final response = await http.get(Uri.parse(
        "https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=$id"));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Catid.FromJson(e)).toList();
    } else {
      throw Exception('Failed to load property');
    }
  }

  Future<List<RealEstateSlider>> fetchSlider() async {
    final id = await getPropertyID();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: CustomBackButton(),title: Text('VERIFY',style: TextStyle(color: Colors.white,fontSize: 40,fontFamily: 'Poppins',fontWeight: FontWeight.w500),),backgroundColor: Colors.blue.shade900,
        centerTitle: true,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      FutureBuilder<List<RealEstateSlider>>(
                        future: _sliderFuture,
                        builder: (context, sliderSnap) {
                          return buildImageSection(data, sliderSnap.data ?? []);
                        },
                      ),
                      const SizedBox(height: 16),
                      buildTitleAndLocation(data),
                      const SizedBox(height: 16),
                      buildFeatureChips(data),
                      const SizedBox(height: 16),
                      buildStatsRow(data),
                      const SizedBox(height: 16),
                      Divider(color: Colors.grey,),
                      Text(
                        data.Building_information,
                        style: GoogleFonts.poppins(color: Colors.grey,fontSize: 20),
                      ),
                      Divider(color: Colors.grey,),

                      const SizedBox(height: 30),
                      buildBottomBar(data),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }


  Widget buildImageSection(Catid data, List<RealEstateSlider> sliders) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://verifyserve.social/${data.Building_image}',
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sliders.length,
            itemBuilder: (context, index) {
              final img = sliders[index].rimg!;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewScreen(
                        imageUrls:
                        sliders.map((e) => e.rimg!).toList(),
                        initialIndex: index,
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade900),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      'https://verifyserve.social/$img',
                      width: 80,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget buildTitleAndLocation(Catid data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flag, color: Colors.red, size: 16),
            const SizedBox(width: 6),
            Text(data.Building_Location,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 6),
        Text(data.tyope,
            style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ],
    );
  }

  Widget buildFeatureChips(Catid data) {
    return Wrap(
      spacing: 10,
      children: [
        chip(Icons.check_circle, data.Furnished),
        chip(Icons.local_parking, 'Parking'),
        chip(Icons.pool, 'Pool'),
      ],
    );
  }

  Widget chip(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.black54),
      label: Text(label, style: GoogleFonts.poppins(color: Colors.black)),
      backgroundColor: Colors.grey.shade300,
      shape: StadiumBorder(side: BorderSide(color: Colors.black54)),
    );
  }

  Widget buildStatsRow(Catid data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        statTile(Icons.bed, '${data.BHK}', 'Bed'),
        statTile(Icons.bathtub, '${data.Baathroom}', 'Bath'),
        statTile(Icons.house, '${data.tyope}', 'Floor'),
        statTile(Icons.square_foot, '${data.sqft}', 'Sqft'),
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
                color: Colors.black, fontWeight: FontWeight.bold)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget buildBottomBar(Catid data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('₹ ${data.Rent + data.Verify_price}',
            style: GoogleFonts.poppins(
                fontSize: 20, color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text("Book Schedule", style: GoogleFonts.poppins()),
        )
      ],
    );
  }
}
