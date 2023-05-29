import 'package:flutter/material.dart';
import 'package:locate_test/home_page.dart';

// Here we are using a global variable. You can use something like
// get_it in a production app.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialize the database
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.dark(),
    );
  }
}
