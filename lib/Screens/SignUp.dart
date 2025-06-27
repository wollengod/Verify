import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/Screens/Real%20Estate/Homepage.dart';
import 'package:verify/custom_widget/Paths.dart';
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with Logo and Back Button
                Container(
                  width: double.infinity,
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const CustomBackButton(),
                      const SizedBox(width: 16),
                      Image.asset(AppImages.appbar, height: 100),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children:  [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Sign up to get started with Verify App",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Input Fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      buildTextField(
                        controller: _nameController,
                        hint: 'Full Name',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _mobileController,
                        hint: 'Phone Number',
                        icon: Icons.call,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _emailController,
                        hint: 'Email Address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: _passController,
                        hint: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 30),

                      // Sign Up Button
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            final url = Uri.parse('https://verifyserve.social/PHP_Files/Ragister_Main_App/ragister.php');

                            final response = await http.post(
                              url,
                              headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                              },
                              body: {
                                'FullName': _nameController.text.trim(),
                                'Mobile': _mobileController.text.trim(),
                                'Email': _emailController.text.trim(),
                                'Passwords': _passController.text.trim(),
                              },
                            );

                            setState(() => _isLoading = false);

                            if (response.statusCode == 200) {
                              final data = jsonDecode(response.body);
                              final user = data['user']; // must match your API response
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.setBool(SplashScreenState.KEY_LOGIN, true);
                              await prefs.setString('name', user['FullName']);
                              await prefs.setString('email', user['Email']);
                              await prefs.setString('mobile', user['Mobile']);
                              await prefs.setInt('id', user['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Sign up successful")),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const Homepage()),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Failed to sign up. Try again.")),
                              );
                            }
                          }
                        },
                        child: Container(
                          width: double.infinity,
                          height: 55,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                ?Theme.of(context).textTheme.bodyMedium!.color,
                                ?Theme.of(context).textTheme.bodyMedium!.color,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                :  Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
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

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_showPassword,
        keyboardType: keyboardType,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color,),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Please enter $hint';
          if (hint == 'Phone Number' && value.trim().length != 10) return 'Enter a valid 10-digit number';
          if (hint == 'Email Address' && !value.contains('@')) return 'Enter a valid email';
          if (hint == 'Password' && value.length < 6) return 'Password must be at least 6 characters';
          return null;
        },
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Theme.of(context).textTheme.bodyMedium!.color,),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            onPressed: () => setState(() => _showPassword = !_showPassword),
          )
              : null,
          border: InputBorder.none,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        ),
      ),
    );
  }
}
