import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/custom_widget/back_button.dart';
import '../../Themes/theme-helper.dart';
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
          onPressed: filterProperties,
          icon: const Icon(Icons.filter_alt_rounded),
          label: const Text("Apply the filter"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            backgroundColor: Colors.blueAccent,
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
      data.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
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
        backgroundColor: Colors.white,
        body: _futureData == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            _buildAppBar(),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
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
                          decoration: const BoxDecoration(
                            color: Colors.white,
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
                        backgroundColor: Colors.blueAccent,
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
                      return propertyCard(item);
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
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Row(
        children: [
          const CustomBackButton(),
          const Spacer(),
          const Text(
            'VERIFY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
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
                const SizedBox(width: 10),
                TextButton.icon(
                  onPressed: clearFilters,
                  icon: const Icon(Icons.clear, size: 18),
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
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              "Max : ₹ ${_maxBudget.toStringAsFixed(1)} ${_maxBudget < 1 ? "L" : "Cr"}${_maxBudget >= 5 ? "+" : ""}",
              style: const TextStyle(
                color: Colors.blue,
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
          activeColor: Colors.blue,
          inactiveColor: Colors.blue.shade100,
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

  Widget propertyCard(AllModel item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', int.parse(item.id));
        prefs.setString('id_Longitude', item.Longitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                "https://verifyserve.social/${item.Building_image}",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(item.buy_Rent, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.black)),
                      ),
                      Text("₹${item.Verify_price}", style:  TextStyle(fontWeight: FontWeight.bold,color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16,color: Colors.grey,),
                      const SizedBox(width: 4),
                      Expanded(child: Text(item.Building_Location, overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black),)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      featureIcon(Icons.bed, "${item.BHK}"),
                      featureIcon(Icons.bathtub_outlined, "${item.Baathroom} Baths"),
                      featureIcon(Icons.square_foot, "1000 Sqft"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget propertyCard2(FilterModel item) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('id_Building', item.id);
        prefs.setString('id_Longitude', item.Longtitude);
        prefs.setString('id_Latitude', item.Latitude);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Full_Property()));
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(1),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),


        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                "https://verifyserve.social/${item.Realstate_image}",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${item.Buy_Rent}", style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                      Text("${item.Typeofproperty}", style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                      Text(" ₹${item.Property_Number} ", style:  TextStyle(fontWeight: FontWeight.bold,color: Colors.blue.shade900,fontSize: 18)),

                    ],
                  ),
                  Text(item.Place_, style: TextStyle(color: AppColors.textColor(context))),
                  Row(
                    children: [
                      const Icon(Icons.bed, size: 16,color: Colors.grey,),
                      const SizedBox(width: 4),
                      Text("${item.Bhk_Squarefit}",style: TextStyle(color: Colors.black),),
                      const SizedBox(width: 80),
                      featureIcon(Icons.bathtub_outlined, "${item.Baathroom} Baths",),
                      const SizedBox(width: 40),
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
