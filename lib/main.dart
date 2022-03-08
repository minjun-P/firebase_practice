import 'package:firebase_practice/notification_controller.dart';
import 'package:firebase_practice/pages/home.dart';
import 'package:firebase_practice/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // 종료상황 홈 백그라운드 상황 둘 다에서 작동함.
  print("Handling a background message: ${message.notification?.body}");
  Get.log('백그라운드 메시지');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialBinding: BindingsBuilder.put(()=>NotificationController()),
      home: const App()
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_,AsyncSnapshot<User?> user ){
        if (user.hasData) {
          return Home(user.data);
        } else {
          return Login();
        }
      },

    );
  }
}
