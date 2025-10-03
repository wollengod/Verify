import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swaven/custom_widget/Paths.dart';
import 'package:swaven/utilities/hex_color.dart';
import 'Real Estate/Homepage.dart';
import 'Loginpage.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEY_LOGIN="login";
  @override
  void initState() {
    super.initState();
    whereToGo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: "#001234".toColor(),
        body: Center(
        child: Image(image: AssetImage(AppImages.logo2)),
    )
    );
  }
  void whereToGo() async {
    var sharedPref= await SharedPreferences.getInstance();
    var isLogin=sharedPref.getBool(KEY_LOGIN) ?? false;
    // var name = sharedPref.getString('name') ?? 'Guest';
    // var email = sharedPref.getString('email') ?? 'guest@gmail.com';
    // int userID= sharedPref.getInt('id') ?? 1;

    //Provider.of<UserModel>(context, listen: false).updateUserData(name, email, userID);

    await Future.delayed(const Duration(milliseconds: 250));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => isLogin ?  Homepage() : const LoginPage(),
      ),
    );
}
}
