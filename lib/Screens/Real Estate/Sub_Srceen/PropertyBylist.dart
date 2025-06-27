// Inside lib/Screens/sub_screens/PropertyListByType.dart
import 'package:flutter/material.dart';

class PropertyListByType extends StatelessWidget {
  final String type;

  const PropertyListByType({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$type Properties')),
      body: Center(child: Text('Listing properties for: $type')),
    );
  }
}
