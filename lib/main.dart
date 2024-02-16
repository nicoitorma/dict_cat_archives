import 'package:dict_cat_archives/authentication/login.dart';
import 'package:dict_cat_archives/firebase_options.dart';
import 'package:dict_cat_archives/providers/project_provider.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectListProvider()),
      ],
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Poppins',
        ),
        initialRoute: '/login',
        routes: {'/login': (context) => const LoginScreen()},
      ),
    );
    // home: const Dashboard());
  }
}
