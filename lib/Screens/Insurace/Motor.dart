
import 'package:flutter/material.dart';
import 'package:verify/Themes/theme-helper.dart';

import '../../custom_widget/Paths.dart';
import '../../custom_widget/back_button.dart';

class Motor extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Image.asset(AppImages.appbar, height: 70),
      leading: CustomBackButton(),
      centerTitle: true,
      backgroundColor: Colors.black,
    ),
    body: Center(child: Text("Motor Insurance Coming Soon",style: TextStyle(color: AppColors.textColor(context),fontSize: 20,fontFamily: 'Poppins',
    ),)),
  );
}