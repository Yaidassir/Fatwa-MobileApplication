import 'package:fatwa/Screens/Get_Started/get_started_qr.dart';
import 'package:fatwa/Views/home_screen.dart';
import 'package:fatwa/constants.dart';
import 'package:fatwa/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/Welcome/welcome_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: title,
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          // inputDecorationTheme: const InputDecorationTheme(
          //   filled: true,
          //   fillColor: Colors.white,
          //   iconColor: kPrimaryColor,
          //   prefixIconColor: kPrimaryColor,
          //   border: OutlineInputBorder(
          //     borderSide: BorderSide.none,
          //   ),
          // )
          ),
      home: HomeScreen(),
    );
  }
}
