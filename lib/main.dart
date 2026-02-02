import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Verify/Screens/Splash.dart';
import 'Themes/theme_provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initLocalNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        print('📩 Notification tapped: ${details.payload}');
        // You can navigate to a screen here if needed
      });
}

// Handle background messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  await initLocalNotifications();


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
      title: 'Verify',
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
    // Request permission
    FirebaseMessaging.instance.requestPermission();

    // Get FCM token
    FirebaseMessaging.instance.getToken().then((token) {
      print("📲 FCM Token: $token");
    });

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("🔔 Foreground message: ${message.notification?.title}");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        await flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'default_channel',       // channel id
              'Default',               // channel name
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // When app opened by tapping notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📩 Notification clicked!");
    });
  }
}
