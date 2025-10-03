import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swaven/Screens/Splash.dart';
import 'Themes/theme_provider.dart';

// 🔥 Firebase imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  FirebaseMessaging.instance.subscribeToTopic("wollengod");


  // Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

    // 🔥 Setup FCM permissions + listeners
    _initFCM();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'swaven',
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
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          onSurface: Colors.white70,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      themeMode: themeProvider.themeMode, // magic here
      home: SplashScreen(),
    );
  }

  void _initFCM() {
    // Request notification permission
    FirebaseMessaging.instance.requestPermission();

    // Get FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      print("📲 FCM Token: $token"); // Use this for sending test notifications
    });

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("🔔 Foreground message: ${message.notification?.title}");
    });

    // When app opened by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 Notification clicked!");
      // 👉 Navigate to a screen if needed
    });
  }
}
