import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Verify/utilities/hex_color.dart';
import '../../custom_widget/property_card.dart';
import '../../custom_widget/wish_button.dart';
import '../../model/Office_model.dart';
import '../../custom_widget/Paths.dart';
import '../../model/buy_flat_card.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<OfficePropertyModel> wishlist = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final userId = await getUserId();
    if (userId == null) return;

    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/wishlist_show.php?user_id=$userId",
    );

    final res = await http.get(url);
    final List data = json.decode(res.body);

    setState(() {
      wishlist = data
          .map((e) => OfficePropertyModel.fromJson(e))
          .toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rent = wishlist
        .where((e) => e.buyRent.toLowerCase() == 'rent')
        .toList();

    final buy = wishlist
        .where((e) => e.buyRent.toLowerCase() == 'buy')
        .toList();

    return Scaffold(
      backgroundColor: "#E3EFFF".toColor(),
      appBar: AppBar(
        title: Image.asset(AppImages.logo2, height: 70),
        centerTitle: true,
        backgroundColor: "#001234".toColor(),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : wishlist.isEmpty
          ? _emptyState()
          : RefreshIndicator(
        color: Colors.blueAccent,
        backgroundColor: Colors.white,
        onRefresh: _loadWishlist,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: [
            if (rent.isNotEmpty) ...[
              _sectionTitle("Rent Properties"),
              ...rent.map(
                    (e) => PropertyCard(
                  item: e,
                  wishlistButton: WishlistRemoveButton(
                    pId: int.parse(e.pId),
                    onRemoved: () {
                      setState(() {
                        wishlist.removeWhere((x) => x.pId == e.pId);
                      });
                    },
                  ),
                ),
              ),
            ],
            if (buy.isNotEmpty) ...[
              const SizedBox(height: 20),
              _sectionTitle("Buy Properties"),
              ...buy.map(
                    (e) => BuyFlatCard(
                  item: e,
                  wishlistButton: WishlistRemoveButton(
                    pId: int.parse(e.pId),
                    onRemoved: () {
                      setState(() {
                        wishlist.removeWhere((x) => x.pId == e.pId);
                      });
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),

    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "No properties in wishlist",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}


