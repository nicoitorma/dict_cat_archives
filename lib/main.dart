import 'package:dict_cat_archives/firebase_options.dart';
import 'package:dict_cat_archives/providers/project_content_provider.dart';
import 'package:dict_cat_archives/providers/project_provider.dart';
import 'package:dict_cat_archives/routes/login.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProjectListProvider()),
        ChangeNotifierProvider(create: (_) => ProjectContentsProvider())
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: false,
          fontFamily: 'Poppins',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
