// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:Verify/utilities/hex_color.dart';
// import '../../../../model/Home_model.dart';
// import '../full property.dart';
//
// class FeatProperty extends StatefulWidget {
//   const FeatProperty({super.key});
//
//   @override
//   State<FeatProperty> createState() => _FeatPropertyState();
// }
//
// class _FeatPropertyState extends State<FeatProperty> {
//   String _number = '';
//   Future<List<Catid>>? _futureFeatured;
//   Future<List<Catid>>? _futureSell;
//   Future<List<Catid>>? _futureRent;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   void _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String number = prefs.getString('number') ?? '';
//     setState(() {
//       _number = number;
//       _futureFeatured = fetchData(" ");
//       _futureSell = fetchData("https://verifyserve.social/Second%20PHP%20FILE/show_data_sale_property/show_data_for_sale_property.php");
//       _futureRent = fetchData("https://verifyserve.social/Second%20PHP%20FILE/show_data_rent_property/show_data_rent_property.php");
//     });
//   }
//
//   Future<List<Catid>> fetchData(String urlString) async {
//     final url = Uri.parse(urlString);
//     final response = await http.get(url);
//     if (response.statusCode == 200) {
//       List data = json.decode(response.body);
//       data.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
//       return data.take(10).map((item) => Catid.FromJson(item)).toList();
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: "#E3EFFF".toColor(),
//       body: ListView(
//         padding: EdgeInsets.zero,
//         children: [
//           _sectionTitle("Featured Property"),
//           _propertyListBuilder(_futureFeatured, 300, propertyGridCard),
//           _sectionTitle("Sell Property"),
//           _propertyListBuilder(_futureSell, 300, propertyCard2),
//           _sectionTitle("Rent Property"),
//           _propertyListBuilder(_futureRent, 300, propertyCard2),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
//
//   Widget _sectionTitle(String title) {
//     return Container(
//       margin: const EdgeInsets.all(12.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.w600,
//                 fontFamily: 'Poppins',
//                 color: Colors.black,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           const Text(
//             "See all",
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.w400,
//               fontFamily: 'Poppins',
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _propertyListBuilder(Future<List<Catid>>? future, double height, Widget Function(Catid) builder) {
//     return FutureBuilder<List<Catid>>(
//       future: future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Center(child: Text('${snapshot.error}'));
//         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: Text(
//               "No Data Found!",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.w500,
//                 fontFamily: 'Poppins',
//               ),
//             ),
//           );
//         }
//
//         final data = snapshot.data!;
//         return SizedBox(
//           height: height,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: data.length,
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             itemBuilder: (context, index) {
//               final item = data[index];
//               return Padding(
//                 padding: const EdgeInsets.only(right: 12.0),
//                 child: SizedBox(width: 250, child: builder(item)),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget propertyGridCard(Catid item) {
//     return GestureDetector(
//       onTap: () async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setInt('id_Building', item.id);
//         prefs.setString('id_Longitude', item.Longitude);
//         prefs.setString('id_Latitude', item.Latitude);
//         Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
//       },
//       child: Card(
//         color: Colors.white,
//         elevation: 4,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 2,
//                 offset: Offset(2, 4),
//               )
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   "https://verifyserve.social/${item.Building_image}",
//                   height: 180,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     height: 180,
//                     color: Colors.grey.shade200,
//                     child: const Icon(Icons.image_not_supported, size: 30),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             item.buy_Rent,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Poppins',
//                               color: Colors.black,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Text(
//                           "₹${item.Rent + item.Verify_price}",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "${item.BHK}",
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontFamily: 'Poppins',
//                             color: Colors.black,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on, size: 15, color: Colors.black),
//                             const SizedBox(width: 4),
//                             Text(
//                               item.Building_Location,
//                               style: const TextStyle(fontSize: 14, color: Colors.black),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget propertyCard2(Catid item) {
//     return GestureDetector(
//       onTap: () async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         prefs.setInt('id_Building', item.id);
//         prefs.setString('id_Longitude', item.Longitude);
//         prefs.setString('id_Latitude', item.Latitude);
//         Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
//       },
//       child: Card(
//         color: Colors.white,
//         elevation: 4,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.grey,
//                 blurRadius: 8,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.network(
//                   "https://verifyserve.social/${item.Building_image}",
//                   height: 165,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) => Container(
//                     height: 165,
//                     color: Colors.grey.shade200,
//                     child: const Icon(Icons.image_not_supported, size: 30),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         Expanded(
//                           child: Text(
//                             item.buy_Rent,
//                             style: const TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Poppins',
//                               color: Colors.black,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Text(
//                           "₹${item.Verify_price}",
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Colors.black,
//                             fontFamily: 'Poppins',
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 6),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "${item.BHK}",
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontFamily: 'Poppins',
//                             color: Colors.black,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on, size: 15, color: Colors.black),
//                             const SizedBox(width: 4),
//                             Text(
//                               item.Building_Location,
//                               style: const TextStyle(fontSize: 14, color: Colors.black),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
