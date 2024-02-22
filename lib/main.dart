import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dict_cat_archives/firebase_options.dart';
import 'package:dict_cat_archives/providers/project_content_provider.dart';
import 'package:dict_cat_archives/providers/project_provider.dart';
import 'package:dict_cat_archives/routes/login.dart';
import 'package:dict_cat_archives/strings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
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
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        fontFamily: 'Sans',
      ),
      home: AnimatedSplashScreen(
        splash: Image.asset('assets/images/DICT-logo.png'),
        nextScreen: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ProjectListProvider()),
            ChangeNotifierProvider(create: (_) => ProjectContentsProvider())
          ],
          child: MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: false,
              fontFamily: 'Sans',
            ),
            home: const LoginScreen(),
          ),
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
        duration: 3000,
      ),
    );
  }
}
