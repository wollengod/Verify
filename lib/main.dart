import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verify/Screens/Splash.dart';
import 'Themes/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'verify',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: Colors.black,          // Active icon/text
          onSurface: Colors.black87,     // Inactive icon/text
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor:
        //Theme.of(context).brightness==Brightness.dark?Colors.white:
        Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onSurface: Colors.white70,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),

      themeMode: themeProvider.themeMode, //  magic here
      home:  SplashScreen(),
    );
  }
}
