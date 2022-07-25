import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'constants/colors.dart';
import 'ui/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCpecNn2WMqCsdEmQ0vsn4vK9yTjoioZCU',
        appId: '1:157840866902:web:506f02add50a273d46c5f7',
        messagingSenderId: '157840866902',
        projectId: 'instagram-clone-2cd2f',
        storageBucket: 'instagram-clone-2cd2f.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: AppColors.mobileBackGroundColor),
      // home: const ResponsiveLayout(
      //   webLayout: WebScreenLayout(),
      //   mobileLayout: MoblieScreenLayout(),
      // ),
      home: const LoginScreen(),
    );
  }
}
