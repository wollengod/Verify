import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify/custom_widget/Paths.dart';
import 'Real Estate/Homepage.dart';
import 'Reset_password/forget.dart';
import 'SignUp.dart';
import 'Splash.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;
  bool _showPassword = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  Future<void>loginUser() async {
    const String url = 'https://verifyserve.social/PHP_Files/Login_Main_App/Login_Main_APP.php';
    final response  = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {
              'Mobile': _mobileController.text,
              'Passwords': _passController.text,
            }
        ));
    final data= json.decode(response.body);
    print("Response Body loginpage: ${response.body}");
    if(response.statusCode==200 && data['status'] == 'success'){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:
        Text(data['message'] ??'User Login Successfully'),
        ),
      );
      final String fullNameFromAPI = data['user']['FullName']; // fixed casing
      final String emailFromAPI = data['user']['Email'];       // fixed casing
      final int IDFromAPI = data['user']['id'];                // already an int
      final String mobileFromAPI = data['user']['Mobile'];
      //Login saved here.
      var shared_pref= await SharedPreferences.getInstance();
      await shared_pref.setBool(SplashScreenState.KEY_LOGIN, true);
      await shared_pref.setString('name', fullNameFromAPI);
      await shared_pref.setString('email', emailFromAPI);
      await shared_pref.setString('number', mobileFromAPI);
      await shared_pref.setInt('id', IDFromAPI);

      //profile(fullNameFromAPI,emailFromAPI,IDFromAPI);
      Navigator.push(context, MaterialPageRoute(builder: (context)
      => Homepage(),
      ));

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.black,
                  child: Image.asset(
                    AppImages.appbar,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                         Text(
                          "Welcome Back!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        const SizedBox(height: 8),
                         Text(
                          "Login to your account",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            color: Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        const SizedBox(height: 40),

                        buildTextField(
                          controller: _mobileController,
                          hint: 'Phone Number',
                          icon: Icons.call,
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Enter phone number'
                              : null,
                        ),
                        const SizedBox(height: 20),

                        buildTextField(
                          controller: _passController,
                          hint: 'Password',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          validator: (value) =>
                          value == null || value.isEmpty
                              ? 'Enter password'
                              : null,
                        ),
                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => Forget()),
                              );
                            },
                            child:  Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium!.color,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        GestureDetector(
                          onTap: (){
                            if(_formkey.currentState!.validate()){
                              loginUser();
                            }
                            else{
                              print('Not working');
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
                              boxShadow: [
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
                                "Login",
                                style: TextStyle(
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don’t have an account? "),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpPage()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodyMedium!.color,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ]
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
    String? Function(String?)? validator,
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
        validator: validator,
        style:  TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color,),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Theme.of(context).textTheme.bodyMedium!.color,),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _showPassword ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            ),
            onPressed: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
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
