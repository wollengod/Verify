import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              color: Colors.black,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const CustomBackButton(),
                  const SizedBox(width: 40),
                  Image.asset(AppImages.appbar, height: 60),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: FutureBuilder<List<Catid>>(
                future: _propertyFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final data = snapshot.data!.first;

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Combined Image Section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // MAIN IMAGE from `Building_image`
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'https://verifyserve.social/${data.Building_image}',
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      // Title & Location
                      Expanded(
                        child: Text(
                          data.tyope,
                          style: TextStyle(
                            fontSize: 25 ,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          overflow: TextOverflow.visible,
                          softWrap: true,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            data.Building_Location,
                            style: TextStyle(color: textColor),
                          ),
                          const Spacer(),
                          const Icon(Icons.directions_walk, size: 16),
                          const SizedBox(width: 4),
                          const Text("780m (12 min)"),
                        ],
                      ),

                      const Divider(height: 32),

                      // Description
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Description", style: Theme.of(context).textTheme.titleMedium),
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 18),
                              SizedBox(width: 4),
                              Text("4.8 (112)", style: TextStyle(fontSize: 14)),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.Building_information,
                        style: TextStyle(color: textColor),
                      ),

                      const Divider(height: 32),

                      // Amenities Grid
                      Text("Amenities", style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 20,
                        runSpacing: 12,
                        children: [
                          //amenity(Icons.pool, 'Swimming'),
                          amenity(Icons.bathtub, '${data.Baathroom} Bathroom'),
                          amenity(Icons.bed, '${data.BHK}'),
                          amenity(Icons.square_foot, '${data.sqft} sqft'),
                          //amenity(Icons.wifi, 'Free WiFi'),
                         // amenity(Icons.local_parking, 'Parking'),
                          amenity(Icons.kitchen, '${data.kitchen} Kitchen'),
                          amenity(Icons.star, '${data.Furnished}'),
                        ],
                      ),

                      const Divider(height: 30),
                      const SizedBox(height: 20,),
                      Text('Property Images',style: TextStyle(color: textColor,fontSize: 28),),
                      const SizedBox(height: 20,),
                      // CAROUSEL of ADDITIONAL IMAGES
                      FutureBuilder<List<RealEstateSlider>>(
                        future: _sliderFuture,
                        builder: (context, imgSnapshot) {
                          if (!imgSnapshot.hasData) {
                            return const SizedBox.shrink();
                          }

                          return SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: imgSnapshot.data!.length,
                              itemBuilder: (context, index) {
                                final img = imgSnapshot.data![index].rimg!;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: GestureDetector(
                                onTap: () {
                                Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => ImagePreviewScreen(
                                imageUrls: imgSnapshot.data!.map((e) => e.rimg!).toList(),
                                initialIndex: index,),),);
                                },
                                child: Image.network(
                                      'https://verifyserve.social/$img',
                                      width: 160,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 160,
                                        color: Colors.grey.shade200,
                                        child: const Icon(Icons.image_not_supported),
                                      ),
                                    ),
                                  ),
                                ));
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 30,),
                      // Price + Book Now
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹ ${data.Rent + data.Verify_price}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: textColor,
                              foregroundColor: bgColor,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text("Book Now"),
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget amenity(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).iconTheme.color),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color)),
      ],
    );
  }
}
