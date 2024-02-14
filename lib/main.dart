import 'package:dict_cat_archives/dashboard.dart';
import 'package:dict_cat_archives/firebase_options.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
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
      title: appName,  
      themeMode: ThemeMode.system,
      home: const Dashboard(),
    );
  }
}



