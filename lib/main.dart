import 'package:flutter/material.dart';
import 'RequestHelper.dart';
import 'HomePage.dart';
import 'LoginPages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: FutureBuilder(
        future: RequestHelper.login(context),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == "OK") {
              return HomePage();
            } else {
              return LoginPages();
            }
          } else {
            return Container(
              child: Center(
                child: Text("Betöltés..."),
              ),
            );
          }
        },
      ),
    );
  }
}
