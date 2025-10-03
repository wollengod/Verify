
import 'package:flutter/material.dart';
import 'package:swaven/utilities/hex_color.dart';

import '../../custom_widget/Paths.dart';
import '../../custom_widget/back_button.dart';

class Motor extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: "#EEF5FF".toColor(),
    appBar: AppBar(
      title:
      Image.asset(AppImages.logo2, height: 70),
      centerTitle: true,
      backgroundColor: "#001234".toColor(),
      surfaceTintColor: "#001234".toColor(),

      leading: CustomBackButton(),
    ),
    body: SingleChildScrollView(
    child: Center(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 100,),
          Image.asset('assets/Icons/car.png', width: 100, height: 100),
          SizedBox(height: 20),
          Text(
            "Vehicle Alert!!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "We're working on something amazing.",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            "Launching soon!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),

          SizedBox(height: 30),
          CircularProgressIndicator(
            color: Colors.black,
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: "#001234".toColor(),
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
  ));
}