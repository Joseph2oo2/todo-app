
import 'package:firebase/Screens/add_task_page.dart';
import 'package:firebase/Screens/login_page.dart';
import 'package:firebase/Screens/register_page.dart';
import 'package:firebase/Screens/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'Screens/todo_home_page.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: TextTheme(
            displayMedium:TextStyle(color: Colors.white,fontSize: 18,),
            displaySmall:TextStyle(color: Colors.white70,fontSize: 14)
        ),
        scaffoldBackgroundColor: Colors.blueGrey.shade900,

        appBarTheme: AppBarTheme(color:Colors.blueGrey.shade900 ,iconTheme:IconThemeData(color: Colors.white) ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      initialRoute: '/splash',
      routes: {
        '/':(context) => LoginPage(),
        '/register':(context) => RegisterPage(),
        '/home':(context) => TodoHomePage(),
        '/addtask':(context) => AddTaskPage(),
        '/splash':(context) => SplashPage(),
      },

    );
  }
}


