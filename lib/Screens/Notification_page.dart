import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_widget/Paths.dart';
import '../custom_widget/back_button.dart';
import '../model/Notification_model.dart';
import '../utilities/hex_color.dart';

class NotificationInboxPage extends StatefulWidget {
  const NotificationInboxPage({super.key});

  @override
  State<NotificationInboxPage> createState() => _NotificationInboxPageState();
}

class _NotificationInboxPageState extends State<NotificationInboxPage> {
  /// This list will later be populated from API / FCM
  List<AppNotification> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }


  /// TEMP: Dummy loader
  /// FUTURE: Replace with API / local DB / FCM handler
  void _loadNotifications() async{
    notifications = [
      AppNotification(
        id: "1",
        title: "Booking Confirmed",
        message: "Your visit for 2 BHK Flat in Sultanpur is confirmed.",
        time: "2 hours ago",
        icon: Icons.check_circle,
        color: Colors.green,
        type: NotificationType.booking,
        isRead: false,
      ),
      AppNotification(
        id: "2",
        title: "New Property Recommendation",
        message: "A new premium flat is available near your location.",
        time: "Yesterday",
        icon: Icons.home,
        color: Colors.blue,
        type: NotificationType.recommendation,
        isRead: false,
      ),
      AppNotification(
        id: "3",
        title: "Price Update",
        message: "Price dropped for a property you viewed earlier.",
        time: "2 days ago",
        icon: Icons.trending_down,
        color: Colors.orange,
        type: NotificationType.priceUpdate,
        isRead: true,
      ),
    ];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_unread_notifications', false);

    for (var n in notifications) {
      n.isRead = true;
    }

    setState(() {});
  }

  void _onNotificationTap(AppNotification notification) {
    // Mark as read locally (future: sync with backend)
    setState(() {
      notification.isRead = true;
    });

    // FUTURE ROUTING
    // if (notification.type == NotificationType.booking) { ... }
    // if (notification.type == NotificationType.property) { ... }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: Image.asset(AppImages.logo2, height: 70),
        centerTitle: true,
        backgroundColor: "#001234".toColor(),
        surfaceTintColor: "#001234".toColor(),

      ),
      body: notifications.isEmpty
          ? _emptyState()
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final n = notifications[index];
          return _notificationTile(n);
        },
      ),
    );
  }
  Widget _notificationTile(AppNotification n) {
    return GestureDetector(
      onTap: () => _onNotificationTap(n),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: n.color.withOpacity(0.12),
              child: Icon(n.icon, color: n.color, size: 22),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n.message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    n.time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),

            // 🔵 Unread dot
            if (!n.isRead)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.notifications_off_outlined,
              size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            "You're all caught up",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "No new notifications",
            style: TextStyle(
              fontSize: 13,
              color: Colors.black38,
            ),
          ),

        ],
      ),
    );
  }
}
