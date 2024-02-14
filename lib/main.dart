import 'package:dict_cat_archives/drawer.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {  


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title:  Text(appName, style: const TextStyle(color: Colors.white, 
      shadows: [Shadow(
        offset: Offset(1.0, 1.0),
        color: Colors.grey)])),
      flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color.fromARGB(180, 0, 83, 184), Color.fromARGB(120, 62, 180, 137)], begin: Alignment.bottomLeft, end: Alignment.topRight)),),),
      drawer: const CustomDrawer(),

      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'HEHEHEHE'
            ),
          ],
        ),
      ),
      
    );
  }
}
