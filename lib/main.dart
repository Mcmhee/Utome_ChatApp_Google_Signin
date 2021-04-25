import 'package:firebase_core/firebase_core.dart';
import 'package:first_flutter_app/services/auth.dart';
import 'package:first_flutter_app/views/home.dart';
import 'package:first_flutter_app/views/signin.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (BuildContext context, Widget widget) {
        Widget error = Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget;
      },
      theme: ThemeData(primarySwatch: Colors.purple),
      home: FutureBuilder(
        future: AuthFunctions().getcurrentuser(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return home();
          } else {
            return signin();
          }
        },
      ),
    );
  }
}
