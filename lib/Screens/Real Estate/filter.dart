import 'dart:convert';
import 'package:verify/utilities/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/custom_widget/back_button.dart';
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
  String selectedBHK = '1 BHK';
  String selectedPlace = 'Sultanpur';
  bool isFiltering = false;
  List<FilterModel> filteredData = [];
  bool noResult = false;
  Future<List<AllModel>>? _futureData;
  double _minBudget = 0.0;
  double _maxBudget = 500.0;


  @override
  void initState() {
    super.initState();
    _futureData = fetchData();
  }
  Widget buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: (){
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 100), () {
              filterProperties();
            });
          },
          icon: const Icon(Icons.filter_alt_rounded),
          label: const Text("Apply the filter"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: "#001234".toColor(),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 3,
          ),
        ),
        const SizedBox(width: 10),
        if (filteredData.isNotEmpty || noResult)
          TextButton.icon(
            onPressed: clearFilters,
            icon: const Icon(Icons.refresh),
            label: const Text("Reset"),
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          )
      ],
    );
  }

  Future<void> filterProperties() async {
    setState(() {
      isFiltering = true;
      noResult = false;
    });

    final queryParams = {
      'Buy_Rent': selectedBuyRent,
      'Place_': selectedPlace,
      if (selectedBHK != 'All') 'Bhk_Squarefit': selectedBHK,
    };

    final uri = Uri.https(
      'verifyserve.social',
      '/WebService4.asmx/filter_all_category_data',
      queryParams,
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List && decoded.isNotEmpty) {
          setState(() {
            filteredData = decoded
                .map<FilterModel>((item) => FilterModel.fromJson(item))
                .toList();
            noResult = false;
          });
        } else {
          setState(() {
            noResult = true;
            filteredData = [];
          });
        }
      } else {
        throw Exception('Failed to load filtered data');
      }
    } catch (e) {
      setState(() {
        isFiltering = false;
        noResult = true;
        filteredData = [];
      });
      print("Error parsing JSON or fetching data: $e");
    } finally {
      setState(() => isFiltering = false);
    }
  }




  Future<List<AllModel>> fetchData() async {
    final url = Uri.parse(
        "https://verifyserve.social/PHP_Files/show_all_category_website_data/show_all_category_data.php");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      //data.sort((a, b) => a['PVR_id'].compareTo(b['PVR_id'])); // ascending
      data.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id'])); //descending

      return data.map((item) => AllModel.FromJson(item)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  final List<String> buyRentOptions = ['Buy', 'Rent'];
  final List<String> bhkOptions = [
    '1 BHK',
    '2 BHK',
    '3 BHK',
    '1 RK',
    'Commercial',
  ];
  final List<String> placeOptions = [
    'Sultanpur',
    'Chhattarpur',
    'Manglapuri',
    'Rajpur Khurd'
  ];

  void clearFilters() {
    setState(() {
      selectedBuyRent = 'Buy';
      selectedBHK = '1 BHK';
      selectedPlace = 'Sultanpur';
      filteredData.clear();
      noResult = false;
      isFiltering = false;
      _futureData = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: "#EEF5FF".toColor(),
        body: _futureData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            _buildAppBar(),
            Container(
              decoration: BoxDecoration(
                color: "#EEF5FF".toColor(),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Filters", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black,fontFamily: 'Poppins')),
                    if (filteredData.isNotEmpty || noResult) ...[
                      const SizedBox(width: 10),
                      TextButton.icon(
                        onPressed: clearFilters,
                        icon: const Icon(Icons.clear, size: 18),
                        label: const Text("Clear"),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ],
                    ElevatedButton.icon(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => Container(
                          decoration:  BoxDecoration(
                            color: "#EEF5FF".toColor(),
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: SingleChildScrollView(child: _buildFilterRow()),
                        ),

                      ),
                      icon: const Icon(Icons.tune),
                      label: const Text("Filter"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: "#001234".toColor(),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),

            ),

            Divider(color: Colors.grey,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isFiltering || filteredData.isNotEmpty || noResult
                          ? "Filtered Properties"
                          : "Recommended Properties",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (!isFiltering && !noResult && filteredData.isEmpty)
                    Text("", style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),

            Divider(color: Colors.grey,),
            Expanded(
              child: isFiltering || filteredData.isNotEmpty || noResult
                  ? _buildFilteredResults()
                  : FutureBuilder<List<AllModel>>(
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
                    padding: const EdgeInsets.all(10),
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return recommendedPropertyCard(item); // ⬅ replaced old card
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: "#001234".toColor(),

        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        children: [
          const CustomBackButton(),
          const Spacer(),
          Image.asset(AppImages.logo2, height: 70),
          const Spacer(flex: 2),
        ],
      ),
    );
  }



  Widget _buildFilterRow() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Filters to get better results",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 4),
          const Text(
            "Choose the filters which can be changed later on",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
                fontFamily: 'Poppins'),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _dropdownCard('Buy/Rent', buyRentOptions, selectedBuyRent, (val) {
                setState(() => selectedBuyRent = val!);
              }),
              _dropdownCard('BHK Type', bhkOptions, selectedBHK, (val) {
                setState(() => selectedBHK = val!);
              }),
              _dropdownCard('Location Area', placeOptions, selectedPlace, (val) {
                setState(() => selectedPlace = val!);
              }),
              _buildBudgetSlider(),

            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              buildFilterButtons(),
              if (filteredData.isNotEmpty || noResult) ...[
                TextButton.icon(
                  onPressed: clearFilters,
                  icon: const Icon(Icons.clear, size: 14),
                  label: const Text("Clear"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Budget in ₹",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Min : ₹ ${_minBudget.toStringAsFixed(1)} ${_minBudget < 1 ? "L" : "Cr"}",
              style:  TextStyle(
                color: "#001234".toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "Max : ₹ ${_maxBudget.toStringAsFixed(1)} ${_maxBudget < 1 ? "L" : "Cr"}${_maxBudget >= 5 ? "+" : ""}",
              style:  TextStyle(
                color: "#001234".toColor(),
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        RangeSlider(
          values: RangeValues(_minBudget, _maxBudget),
          min: 0,
          max: 500, // up to 5 Cr in Lakh
          divisions: 100, // smoother thumb control
          activeColor: "#001234".toColor(),
          inactiveColor: Colors.grey.shade500,
          labels: RangeLabels(
            _formatPrice(_minBudget),
            _formatPrice(_maxBudget),
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _minBudget = values.start;
              _maxBudget = values.end;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("₹ 0 L", style: TextStyle(fontFamily: 'Poppins')),
              Text("₹ 1 Cr"),
              Text("₹ 2 Cr"),
              Text("₹ 3 Cr"),
              Text("₹ 4 Cr"),
              Text("₹ 5 Cr+"),
            ],
          ),
        ),

      ],
    );
  }


  String _formatPrice(double value) {
    if (value >= 100) {
      return '₹ ${(value / 100).toStringAsFixed(1)} Cr';
    } else {
      return '₹ ${value.toStringAsFixed(0)} L';
    }
  }


  Widget _dropdownCard(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins',color: Colors.black)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            value: selectedValue,
            onChanged: onChanged,
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            style: const TextStyle(color: Colors.black),
            dropdownColor: Colors.white,
            items: items.map((val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val, style: const TextStyle(fontFamily: 'Poppins')),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }



  Widget _buildFilteredResults() {
    if (isFiltering) {
      return const Center(child: CircularProgressIndicator());
    } else if (noResult) {
      return const Center(child: Text("No Properties Found!", style: TextStyle(fontSize: 18)));
    } else {
      return Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "${filteredData.length} property result(s) found",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final item = filteredData[index];
                return propertyCard2(item);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget recommendedPropertyCard(AllModel item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', int.parse(item.id));
        prefs.setString('id_Longitude', item.Longitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Full_Property()));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 20),
        color: "#F5F8FF".toColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://verifyserve.social/${item.Building_image}",
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
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _badge(item.buy_Rent, Colors.blue.shade800),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _badge(item.tyope, Colors.black.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _nestedSpecCard(Icons.bed, "${item.BHK}"),
                  _nestedSpecCard(Icons.bathtub, "${item.Baathroom} Bath"),
                  _nestedSpecCard(Icons.square_foot, "1000 Ft"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        "₹ ${item.Verify_price}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.Building_Location,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            "New Delhi 110030",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }


  Widget propertyCard2(FilterModel item) {
    final rawPrice = item.Property_Number;


    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', item.id);
        prefs.setString('id_Longitude', item.Longtitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Full_Property()));
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 20),
        color: "#F5F8FF".toColor(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "https://verifyserve.social/${item.Realstate_image}",
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
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _badge(item.Buy_Rent, Colors.blue.shade800),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _badge(item.Typeofproperty, Colors.black.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _nestedSpecCard(Icons.bed, "${item.Bhk_Squarefit}"),
                  _nestedSpecCard(Icons.bathtub, "${item.Baathroom} Bath"),
                  _nestedSpecCard(Icons.square_foot, "900 Ft"),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Text(
                        "₹ ${rawPrice}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.Place_,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            "New Delhi 110030",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Colors.black87),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.black, fontFamily: 'Poppins')),
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


  Widget featureIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16,color: Colors.grey,),
        const SizedBox(width: 4),
        Text(label,style: TextStyle(color: Colors.black),),
      ],
    );
  }
}
