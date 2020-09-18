import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'LoginForm.dart';
import 'UniversitiesList.dart';
import 'RequestHelper.dart';
import 'HomePage.dart';
import 'globals.dart' as globals;
//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flushbar/flushbar.dart';

class LoginPages extends StatelessWidget {
  const LoginPages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return generatePages(context);
  }

  void showFlushbar(String text, BuildContext context) {
    Flushbar(
      message: text,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  Widget generatePages(context) {
    const bodyStyle = TextStyle(fontSize: 19.0, color: Colors.white);
    const pageDecoration = const PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
        bodyTextStyle: bodyStyle,
        descriptionPadding: EdgeInsets.fromLTRB(16.0, 56.0, 16.0, 16.0),
        pageColor: Colors.black,
        titlePadding: EdgeInsets.fromLTRB(20, 100, 20, 20));
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "e-Pluto",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Ez egy kísérleti nonprofit kliens a NEPTUN rendszerhez\n"
                  "\n"
                  "Ezt az alkalmazást nem az SDA Informatika Zrt. készítette, és nem helyettesíti az ő szoftvereiket.\n"
                  "\n"
                  "Probléma esetén írj egy e-mailt ezen app fejlesztőjének:\n"
                  "s4k11@tuta.io\n"
                  "\n"
                  "Csak saját felelősségre használható",
                  style: bodyStyle)
            ],
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Egyetem választása",
          bodyWidget: UniversitiesList(),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Bejelentkezés",
          bodyWidget: LoginForm(),
          decoration: pageDecoration,
        ),
      ],
      onDone: () {
        if (globals.loginFormKey.currentState.validate()) {
          RequestHelper.storage.read(key: "universityUrl").then((universityUrl) async {
            String username = globals.usernameController.text;
            await RequestHelper.storage.write(key: "username", value: username);
            String password = globals.passwordController.text;
            await RequestHelper.storage.write(key: "password", value: password);
            String loginResult = await RequestHelper.login(context);
            if (loginResult == "OK") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            } else {
              showFlushbar(loginResult, context);
            }
          });
        }
      },
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      next: const Icon(Icons.arrow_forward),
      done: const Text('Bejelentkezés', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
