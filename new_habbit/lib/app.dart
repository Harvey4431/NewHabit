import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'habit_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      home: HabitPage(),
    );
  }
}
