import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:verify/utilities/hex_color.dart';
import '../../Themes/theme-helper.dart';
import '../../custom_widget/Paths.dart';
import '../../custom_widget/back_button.dart';
import '../../model/service_model.dart';
import 'Booking_form.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  late Future<List<ServiceModel>> _serviceFuture;

  @override
  void initState() {
    super.initState();
    _serviceFuture = fetchServices();
  }

  Future<List<ServiceModel>> fetchServices() async {
    final url = Uri.parse("https://verifyserve.social/WebService1.asmx/ShowServiceCat");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body) as List;
      return decoded.map((json) => ServiceModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load services");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor:  "#EEF5FF".toColor(),
      appBar: AppBar(
        title: Image.asset(AppImages.logo2, height: 70),
        centerTitle: true,
        backgroundColor: "#001234".toColor(),
        surfaceTintColor: "#001234".toColor(),

        leading: CustomBackButton(),
      ),
      body: Column(
        children: [
          Container(
           // margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(color: "#001234".toColor(),),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("Available Services", style: TextStyle(fontFamily: 'Poppins',fontSize: 23,color: Colors.white,fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ServiceModel>>(
              future: _serviceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return
                    //const Center(child: CircularProgressIndicator());
                   GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 3 / 2.8,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No services found"));
                }

                final services = snapshot.data!;

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 3 / 2.8,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return serviceCard(service);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget serviceCard(ServiceModel service) {
     return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceBookingPage(
              serviceID: service.id.toString(),
              serviceName: service.name,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child:Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  "https://verifyserve.social/upload/${service.image}",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey.shade300,width: 200, child: const Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                service.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
