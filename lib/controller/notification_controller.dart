import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void showNotification() async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'channel_id',
    'channel_name',
    importance: Importance.high,
    priority: Priority.high,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID (use a different value for each notification)
    'Notification title',
    'Notification body',
    platformChannelSpecifics,
    payload: 'notification_payload',
  );
  print('notificaton should be shown');
}
