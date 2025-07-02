import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/custom_widget/back_button.dart';
import '../../Themes/theme-helper.dart';
import '../../custom_widget/Paths.dart';
import '../../model/All_model.dart';
import '../../model/filter_model.dart';
import 'Sub_Srceen/full property.dart';

class FilterProperty extends StatefulWidget {
  const FilterProperty({super.key});

  @override
  State<FilterProperty> createState() => _FilterPropertyState();
}

class _FilterPropertyState extends State<FilterProperty> {
  String selectedBuyRent = 'Buy';
  String selectedBHK = 'All';
  String selectedPlace = 'SultanPur';
  bool isFiltering = false;
  List<FilterModel> filteredData = [];
  bool noResult = false;

  Future<void> filterProperties() async {
    setState(() {
      isFiltering = true;
      noResult = false;
    });

    final url = Uri.parse(
      "https://verifyserve.social/PHP_Files/filter_for_all_category_date/filter_all_gategory.php",
    );

    final response = await http.post(
      url,
      body: {
        'Buy_Rent': selectedBuyRent,
        'Place_': selectedPlace,
        'Bhk_Squarefit': selectedBHK,
      },
    );

    if (response.statusCode == 200) {
      List jsonData = json.decode(response.body);
      if (jsonData.isEmpty) {
        setState(() {
          noResult = true;
          filteredData = [];
          isFiltering = false;
        });
      } else {
        setState(() {
          filteredData = jsonData.map((e) => FilterModel.FromJson(e)).toList();
          noResult = false;
          isFiltering = false;
        });
      }
    } else {
      setState(() {
        isFiltering = false;
      });
      throw Exception('Failed to load filtered data');
    }
  }

  final List<String> buyRentOptions = ['Buy', 'Rent'];
  final List<String> bhkOptions = [
    '1 BHK',
    '2 BHK',
    '3 BHK',
    '4 BHK',
    '1 RK',
    'Commercial',
    'All'
  ];
  final List<String> placeOptions = [
    'SultanPur',
    'Ghitorni',
    'Chattarpur',
    'Aya Nagar/Arjan Garh'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgColor(context),
          body: Column(
            children: [
              _buildAppBar(),
              _buildFilterRow(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Featured Property",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                      ),
                    ),
                    Text("See all", style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Expanded(child: _buildFilteredResults())
            ],
          ),
        ));
  }

  Widget _buildAppBar() {
    return Container(
      height: 80,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const CustomBackButton(),
          const SizedBox(width: 35),
          Image.asset(AppImages.appbar, height: 100),
        ],
      ),
    );
  }


  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _dropdownCard('Buy/Rent', buyRentOptions, selectedBuyRent, (val) {
                setState(() => selectedBuyRent = val!);
              }),
              _dropdownCard('BHK', bhkOptions, selectedBHK, (val) {
                setState(() => selectedBHK = val!);
              }),
              _dropdownCard('Location', placeOptions, selectedPlace, (val) {
                setState(() => selectedPlace = val!);
              }),
            ],
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: filterProperties,
              icon: const Icon(Icons.search, size: 18),
              label: const Text("Apply Filter"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownCard(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
    return Container(
      width: double.infinity,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Theme.of(context).cardColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        value: selectedValue,
        onChanged: onChanged,
        icon: const Icon(Icons.arrow_drop_down),
        items: items.map((val) {
          return DropdownMenuItem<String>(
            value: val,
            child: Text(val),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildFilteredResults() {
    if (isFiltering) {
      return const Center(child: CircularProgressIndicator());
    } else if (noResult) {
      return const Center(child: Text("No Properties Found!", style: TextStyle(fontSize: 18)));
    } else if (filteredData.isEmpty) {
      return const Center(child: Text("Use the filter to see properties.", style: TextStyle(fontSize: 16)));
    } else {
      return ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (context, index) {
          final item = filteredData[index];
          return propertyCard(item);
        },
      );
    }
  }

  Widget propertyCard(FilterModel item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', item.id);
        prefs.setString('id_Longitude', item.Longtitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child:
              Image.network("https://verifyserve.social/${item.Realstate_image}",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${item.Buy_Rent} • ₹${item.Price}", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(item.Place_, style: TextStyle(color: Colors.grey[700])),
                  Row(
                    children: [
                      Icon(Icons.bed, size: 16),
                      SizedBox(width: 4),
                      Text("${item.Bhk_Squarefit}"),
                      Spacer(),
                      Icon(Icons.square_foot, size: 16),
                      SizedBox(width: 4),
                      Text("1000 sqft")
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
