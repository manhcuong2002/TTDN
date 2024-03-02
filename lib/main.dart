import 'package:flutter/material.dart';
import 'package:test_4/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.blue,
            ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
