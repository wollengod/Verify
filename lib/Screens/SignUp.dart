import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/Screens/Real%20Estate/Homepage.dart';
import 'package:verify/custom_widget/Paths.dart';
import 'package:verify/utilities/hex_color.dart';
import '../custom_widget/back_button.dart';
import 'Splash.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showPassword = false;

  final Color black = Colors.black;
  final Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: "#001234".toColor(),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
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

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign up to get started with Verify App",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      buildTextField(_nameController, 'Full Name', Icons.person),
                      const SizedBox(height: 20),
                      buildTextField(_mobileController, 'Phone Number', Icons.call, keyboardType: TextInputType.phone),
                      const SizedBox(height: 20),
                      buildTextField(_emailController, 'Email Address', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      buildTextField(_passController, 'Password', Icons.lock_outline, isPassword: true),
                      const SizedBox(height: 30),

                      GestureDetector(
                        onTap: _handleSignUp,
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.black)
                                : Text(
                              "Sign Up",
                              style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: TextStyle(color: white)),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hint, IconData icon,
      {bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: white),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_showPassword,
        keyboardType: keyboardType,
        style: TextStyle(color: white),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Please enter $hint';
          if (hint == 'Phone Number' && value.trim().length != 10) return 'Enter a valid 10-digit number';
          if (hint == 'Email Address' && !value.contains('@')) return 'Enter a valid email';
          if (hint == 'Password' && value.length < 6) return 'Password must be at least 6 characters';
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: white),
          prefixIcon: Icon(icon, color: white),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: white,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final url = Uri.parse('https://verifyserve.social/PHP_Files/Ragister_Main_App/ragister.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'FullName': _nameController.text.trim(),
          'Mobile': _mobileController.text.trim(),
          'Email': _emailController.text.trim(),
          'Passwords': _passController.text.trim(),
        },
      );

      setState(() => _isLoading = false);

      try {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final user = data['user'];
          if (user != null) {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool(SplashScreenState.KEY_LOGIN, true);
            await prefs.setString('name', user['FullName']);
            await prefs.setString('email', user['Email']);
            await prefs.setString('mobile', user['Mobile']);
            await prefs.setInt('id', user['id']);

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sign up successful")));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Homepage()));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'] ?? "Signup failed")));
        }
      } catch (e) {
        print("Error parsing signup response: $e");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Something went wrong.")));
      }
    }
  }
}
