import 'package:flutter/material.dart';

class PropertyListByType extends StatelessWidget {
  final String type;

  const PropertyListByType({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Listing properties for: $type',style: TextStyle(fontFamily: 'Poppins'),)),
    );
  }
}
