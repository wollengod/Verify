import 'package:flutter/material.dart';
import 'Rent_flat.dart';
import 'buy_flat.dart';

class FlatPropertyTabs extends StatelessWidget {
  const FlatPropertyTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFE3EFFF),
        body: Column(
          children: [
            const
            TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: "Buy Flat"),
                Tab(text: "Rent Flat"),
              ],
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  FlatPropertyBuy(),
                  FlatPropertyPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
