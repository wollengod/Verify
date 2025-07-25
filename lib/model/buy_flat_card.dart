import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/model/Office_model.dart';
import 'package:intl/intl.dart';
import 'package:verify/utilities/hex_color.dart';
import '../../../Screens/Real Estate/Sub_Srceen/full property.dart';

class BuyFlatCard extends StatelessWidget {
  final OfficePropertyModel item;

  const BuyFlatCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    String displayPrice = item.price.trim();
    String? numericOnly = displayPrice.replaceAll(RegExp(r'[^\d]'), '');
    bool isPureNumber = RegExp(r'^\d+$').hasMatch(displayPrice);

    if (isPureNumber && numericOnly.isNotEmpty) {
      final formatted = NumberFormat('#,##,###').format(int.parse(numericOnly));
      displayPrice = "$formatted";
    }

    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', int.parse(item.pvrId));
        prefs.setString('id_Longitude', item.longitude);
        prefs.setString('id_Latitude', item.latitude);
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Full_Property()));
      },
      child: Card(
        color: "#F5F8FF".toColor(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Card(
                elevation: 4,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        "https://verifyserve.social/${item.realstateImage}",
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                    ),
                    Positioned(top: 10, left: 10, child: _badge(item.buyRent, Colors.yellow.shade800)),
                    Positioned(top: 10, right: 10, child: _badge(item.typeOfProperty, Colors.black.withOpacity(0.7))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(child: _nestedSpecCard(Icons.bed, "${item.floor}")),
                  const SizedBox(width: 6),
                  Expanded(child: _nestedSpecCard(Icons.bathtub, item.bathroom)),
                  const SizedBox(width: 6),
                  Expanded(child: _nestedSpecCard(Icons.square_foot, "2000 Ft")),
                ],
              ),
            ),

            const SizedBox(height: 5),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 4,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:
                  Row(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Text(
                          "₹ $displayPrice",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.place.isNotEmpty ? item.place : "Unknown",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "New Delhi 110030",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )

                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _nestedSpecCard(IconData icon, String label) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 13),
            Flexible(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _badge(String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
    );
  }
}
