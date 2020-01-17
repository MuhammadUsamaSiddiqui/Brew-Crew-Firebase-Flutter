import 'package:brew_crew/screens/wrapper.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      // StreamProvider use to receive / listen User stream, and will be available to it's descendant
      value: AuthService().user,
      child: MaterialApp(
        title: 'Brew and Crew',
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
