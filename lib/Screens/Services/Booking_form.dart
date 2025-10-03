import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaven/utilities/hex_color.dart';
import '../../Themes/theme-helper.dart';
import '../../custom_widget/Paths.dart';
import '../../custom_widget/back_button.dart';

class ServiceBookingPage extends StatefulWidget {
  final String serviceID;
  final String serviceName;

  const ServiceBookingPage({
    super.key,
    required this.serviceName,
    required this.serviceID,
  });


  @override
  State<ServiceBookingPage> createState() => _ServiceBookingPageState();
}

class _ServiceBookingPageState extends State<ServiceBookingPage> {
  String? selectedDate;
  String? selectedTime;
  final TextEditingController locationController = TextEditingController();
  bool isLoading = false;
  final String googleApiKey = "AIzaSyBukKQrrZmGS1KOh2Kyc_G_nHhIzse6gPE";
  List<String> placeSuggestions = [];
  Timer? _debounce;
  double? latitude;
  double? longitude;
  String full_address = '';
  final TextEditingController _Longitude = TextEditingController();
  final TextEditingController _Latitude = TextEditingController();


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  final List<String> timeSlots = [
    '09:00 AM - 12:00 PM',
    '12:00 PM - 03:00 PM',
    '03:00 PM - 06:00 PM',
    '06:00 PM - 08:00 PM',
  ];

  final int visitingCharge = 100;

  void showSnack(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green.shade700,
      ),
    );
  }


  Future<void> _getCurrentLocation() async {
    if (await _checkLocationPermission()) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        _Latitude.text = latitude.toString();
        _Longitude.text = longitude.toString();
      });
    } else {
      await _requestLocationPermission();
    }
  }

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      // Permission granted, try getting the location again
      await _getCurrentLocation();
    } else {
      // Permission denied, handle accordingly
      print('Location permission denied');
    }
  }

  void fetchPlaceSuggestions(String input) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (input.isEmpty) {
        setState(() => placeSuggestions = []);
        return;
      }

      final url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&language=en&components=country:in&key=$googleApiKey';

      final response = await http.get(Uri.parse(url));
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List;
        setState(() {
          placeSuggestions = predictions.map((p) => p['description'] as String).toList();
        });
      } else {
        setState(() => placeSuggestions = []);
      }
    });
  }
  @override
  void dispose() {
    _debounce?.cancel();
    locationController.dispose();
    super.dispose();
  }


  Future<void> bookService() async {
    if (selectedDate == null || selectedTime == null || locationController.text.trim().isEmpty) {
      showSnack("Please fill all fields", error: true);
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userID = prefs.getInt('id')?.toString() ?? '';
    final userName = prefs.getString('name') ?? '';
    final userNumber = prefs.getString('number') ?? '';
    final email = prefs.getString('email') ?? '';

    final Uri url = Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/service_api/service_api.php');
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'user_ids': userID,
      'user_names': userName,
      'email': email,
      'user_number': userNumber ?? '8851988930',
      'services_id': widget.serviceID,
      'service_names': widget.serviceName,
      'suitable_day': selectedDate!,
      'suitable_time': selectedTime!,
      'address_for_services': locationController.text.trim(),
    }
    );
    print(request.fields);

    setState(() => isLoading = true);

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print("➡️ BODY: ${response.body}");  // debug
      if (response.statusCode == 200 && response.body.contains("success")) {
        showSnack("✅ Service booked successfully!");
        Navigator.pop(context);
      } else {
        showSnack("❌ Booking failed", error: true,);
      }
    } catch (e) {
      showSnack("⚠️ Error: $e", error: true);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bgColor = AppColors.bgColor(context);
    // final textColor = AppColors.textColor(context);
    // final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:
        Image.asset(AppImages.logo2, height: 70),
        centerTitle: true,
        backgroundColor: "#001234".toColor(),
        surfaceTintColor: "#001234".toColor(),
        leading: CustomBackButton(),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book ${widget.serviceName}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 24),

                // Date Picker
                buildDatePicker(Colors.black, Colors.white),

                const SizedBox(height: 16),

                // Time Picker
                buildTimeDropdown(Colors.black, Colors.white),

                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: locationController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: "Enter Location",
                    hintText: "Type your address",
                    labelStyle: TextStyle(color: Colors.black),
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.black.withOpacity(0.4)),
                    ),
                  ),
                ),
                //buildLocationField(Colors.black),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1, color: Colors.grey.shade600),
                  ),
                  child: Text.rich(
                      TextSpan(
                          text: 'Note :',
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.black,fontFamily: 'Poppins',letterSpacing: 0),
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' Enter Address manually or get your current Address from one tap on location icon.',
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey.shade900,fontFamily: 'Poppins',letterSpacing: 0),
                            )
                          ]
                      )),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    if (latitude != null && longitude != null) {
                      try {
                        List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);

                        if (placemarks.isNotEmpty) {
                          Placemark place = placemarks.first;
                          String output = "${place.street}, ${place.locality}, ${place.subLocality}, "
                              "${place.administrativeArea}, ${place.subAdministrativeArea}, "
                              "${place.country}, ${place.postalCode}";

                          setState(() {
                            full_address = output;
                            locationController.text = full_address;
                          });

                          print('Your Current Address: $full_address');
                        }
                      } catch (e) {
                        print("Error fetching placemark: $e");
                      }
                    } else {
                      showSnack("⚠️ Location not available", error: true);
                    }
                  },

                  child: Container(

                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(0),topLeft: Radius.circular(0),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                        border: Border.all(width: 1, color: Colors.blue),
                        color: Colors.blue.shade600
                    ),
                    child: Center(child: Text('Get Current Location',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 1),)),
                  ),
                ),
                const SizedBox(height: 24),

                buildPriceSummary(Colors.white, Colors.black),

                const SizedBox(height: 40),

                Center(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : bookService,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Book Now",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildDatePicker(Color textColor, Color cardColor) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: selectedDate ?? ""),
      style: TextStyle(color: textColor),
      decoration: buildInputDecoration("Select Date", textColor),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.blue.shade900,
                  onPrimary: Colors.white,
                  surface: cardColor,
                  onSurface: textColor,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            selectedDate = DateFormat('yyyy-MM-dd').format(picked);
          });
        }
      },
    );
  }

  Widget buildTimeDropdown(Color textColor, Color cardColor) {
    return DropdownButtonFormField<String>(
      decoration: buildInputDecoration("Select Time Slot", textColor),
      dropdownColor: cardColor,
      iconEnabledColor: textColor,
      style: TextStyle(color: textColor, fontFamily: 'Poppins'),
      value: selectedTime,
      items: timeSlots.map((slot) {
        return DropdownMenuItem(
          value: slot,
          child: Text(slot),
        );
      }).toList(),
      onChanged: (value) => setState(() => selectedTime = value),
    );
  }

  Widget buildLocationField(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: locationController,
          onChanged: fetchPlaceSuggestions,
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            labelText: "Enter Location",
            hintText: "Search address...",
            labelStyle: TextStyle(color: textColor),
            hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: textColor),
            ),
          ),
        ),
        ...placeSuggestions.map((suggestion) => ListTile(
          title: Text(suggestion, style: TextStyle(color: textColor)),
          onTap: () {
            locationController.text = suggestion;
            setState(() => placeSuggestions = []);
          },
        )),
        if (placeSuggestions.isEmpty && locationController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "No suggestions found.",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
      ],
    );
  }


  Widget buildPriceSummary(Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: "#EEF5FF".toColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          summaryRow("Visiting Charges", "₹$visitingCharge", textColor),
          summaryRow("Service Charges", "According to Work", textColor),
          const Divider(color: Colors.black,),
          summaryRow("Total", "₹$visitingCharge +", textColor, bold: true),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(String label, Color textColor) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: textColor),
      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: textColor.withOpacity(0.4)),
      ),
    );
  }

  Widget summaryRow(String label, String amount, Color textColor, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: textColor,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15,
              fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
