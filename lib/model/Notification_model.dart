import 'package:flutter/material.dart';

enum NotificationType {
  booking,
  recommendation,
  priceUpdate,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color color;
  final NotificationType type;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
    required this.type,
    this.isRead = false,
  });
}
