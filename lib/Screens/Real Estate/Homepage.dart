import 'package:flutter/material.dart';
import 'package:verify/Screens/Real%20Estate/Home.dart';
import 'package:verify/Screens/Real%20Estate/filter.dart';
import 'package:verify/Screens/profile.dart';
import 'package:verify/utilities/hex_color.dart';

import '../../custom_widget/Paths.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  final List<Widget> pages = const [
    Home(),
    Profile(),
  ];

  void onTabTapped(int index) {
    setState(() => selectedIndex = index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
          //Text('VERIFY',style: TextStyle(color: Colors.white,fontSize: 40,fontFamily: 'Poppins',fontWeight: FontWeight.w500),),
          Image.asset(AppImages.logo2, height: 70),
          centerTitle: true,
          backgroundColor: "#001234".toColor(),
          actions: [
            const SizedBox(width: 40,),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)
                  => FilterProperty()
              ));
            }, icon: Icon(Icons.tune_sharp,color: Colors.white,size: 30,)),
            const SizedBox(width: 10,),
          ],
        ),
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() => selectedIndex = index);
          },
          children: pages,
        ),
        bottomNavigationBar:
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).dividerColor.withOpacity(0.3), // subtle
        ),

        BottomNavigationBar(

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: 'Profile',
            ),
          ],
          currentIndex: selectedIndex,
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          backgroundColor:
          //Colors.black,
          "#001234".toColor(),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
          elevation: 20,
        ),
          ]
      ),
    ));
  }
}
