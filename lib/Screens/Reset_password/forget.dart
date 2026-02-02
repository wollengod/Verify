import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Verify/utilities/hex_color.dart';
import '../../custom_widget/Paths.dart';
import '../../custom_widget/back_button.dart';
import 'otp.dart';

class Forget extends StatefulWidget {
  const Forget({super.key});

  @override
  State<Forget> createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {
  final TextEditingController number = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> checkNumberAndSendOtp(String number) async {
    setState(() => _isLoading = true);

    final apiKey = "ceabde09-483f-11f0-a562-0200cd936042";
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/CheckMobileNumber?FNumber=$number');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final otpUrl = Uri.parse("https://2factor.in/API/V1/$apiKey/SMS/+91$number/AUTOGEN");
      final otpResponse = await http.get(otpUrl);

      if (otpResponse.statusCode == 200) {
        final sessionId = RegExp(r'"Details":"(.*?)"')
            .firstMatch(otpResponse.body)
            ?.group(1);

        if (sessionId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Otp(number: number, sessionId: sessionId),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to send OTP")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mobile number not found")),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: "#001234".toColor(),
      body: Column(
        children: [
          // Header Image
          Container(
            width: double.infinity,
            color: "#001234".toColor(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const CustomBackButton(),
                const SizedBox(width: 16),
                Image.asset(AppImages.logo2, height: 100),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Form Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your registered phone number to receive an OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Phone Number Input
                  Form(
                    key: _formKey,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: TextFormField(
                        controller: number,
                        keyboardType: TextInputType.phone,
                        style:  TextStyle(color: Theme.of(context).scaffoldBackgroundColor,),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: InputBorder.none,
                          hintText: "Phone Number",
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          prefixIcon: const Icon(Icons.call, color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter your phone number';
                          if (value.length != 10) return 'Phone number must be 10 digits';
                          if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) return 'Invalid phone number';
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Continue Button
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        await checkNumberAndSendOtp(number.text);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),

                          gradient: LinearGradient(
                              colors: [
                              ?Theme.of(context).textTheme.bodyMedium!.color,
                          ?Theme.of(context).textTheme.bodyMedium!.color,
                      ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    ),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.black12,
                        //     blurRadius: 5,
                        //     offset: Offset(0, 2),
                        //   ),
                        // ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          "Send OTP",
                          style: TextStyle(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
