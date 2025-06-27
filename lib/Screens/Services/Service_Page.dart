
import 'package:flutter/material.dart';
import 'package:verify/Themes/theme-helper.dart';
import 'package:verify/custom_widget/back_button.dart';

import '../../custom_widget/Paths.dart';

class ServicesPage extends StatelessWidget {
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
        Text("Services Coming Soon",style: TextStyle(color: AppColors.textColor(context),fontSize: 20,fontFamily: 'Poppins',),),
  ));
}