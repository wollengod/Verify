
import 'package:flutter/material.dart';
import 'package:verify/Themes/theme-helper.dart';

import '../../custom_widget/Paths.dart';
import '../../custom_widget/back_button.dart';

class HealthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Image.asset(AppImages.appbar, height: 70),
      leading: CustomBackButton(),
      centerTitle: true,
      backgroundColor: Colors.black,
    ),
    body: Center(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/Icons/cardiogram.png', width: 100, height: 100),
          SizedBox(height: 20),
          Text(
            "Insurance!!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textColor(context),
            ),
          ),
          SizedBox(height: 10),
          Text(
            "We're working on something amazing.",
            style: TextStyle(
              fontSize: 18,
              color: AppColors.textColor(context).withOpacity(0.7),
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Launching soon!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.greenAccent.shade400,
            ),
          ),
          SizedBox(height: 30),
          CircularProgressIndicator(color: AppColors.textColor(context)),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back to Home",style: TextStyle(color: Colors.white),),
          ),

        ],
      ),

    ),
  );
}