import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_practice/pages/notification_detail_page.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void onInit() async{
    // TODO: implement onInit
    // 첫 빌드시, 권한 확인하기
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // 첫 빌드시 토큰 값 프린트
    _getToken();
    // 첫 빌드시 스트림 on 그럼 이제 이 파이프라인을 따라 데이터가 들어올 때마다 메소드
    // 내부의 listener 가 실행됨.
    _onMessage();

    super.onInit();
  }


  Future<void> _getToken() async {
    try{
      String? token = await messaging.getToken();
      print(token);
    } catch (e){}
  }

  void _onMessage() async {
    // 우리가 사용할 특수 채널을 일단 객체 상태로 만들기
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    // 그다음 로컬 알림을 제어하는 plugin 을 객체화 한다.
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    // 위 plugin 을 가지고 채널 객체를 통해 실제 채널을 만든다.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: IOSInitializationSettings()),
        onSelectNotification: (String? payload) async {
          Get.to(()=>NotificationDetailPage(title: '앱이 켜져있는 상황',), arguments: payload);
        });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description
              ),
            ),
            payload: message.data['argument']
        );
      }

      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification!.body}');
      }
    });

    // Background 상태. Notification 서랍에서 메시지 터치하여 앱으로 돌아왔을 때의 동작은 여기서.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage rm) {
      Get.to(NotificationDetailPage(title: '백그라운드 상황(홈키로 나갔을 때)에서 눌렀을 때',));
    });

    // Terminated 상태에서 도착한 메시지에 대한 처리
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Get.to(NotificationDetailPage(title: '앱 종료상황에서 눌렀을 때',),);
    }



  }
}