import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:torq_tracker_feeder/admin/chooseOption.dart';
import 'package:torq_tracker_feeder/admin/discoverPage.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torq Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      initialRoute: "choose",
      routes: {
        //"/login": (context) => LoginScreen(),
        "d": (context) => DiscoveryPage(),
        "choose": (context) => ChooseOption(),
      },
    );
  }
}
