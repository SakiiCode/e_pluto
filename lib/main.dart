import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'dart:convert' show json;
import 'dart:developer';
import 'loginForm.dart';
import 'universitiesList.dart';
import 'RequestHelper.dart';
import 'HomePage.dart';
import 'globals.dart' as globals;
import 'package:cron/cron.dart';

void main() => runApp(MyApp());

setUniversityUrl(String url){
  globals.universityUrl=url;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context){


    RequestHelper.getInstitutes().then((value) {
      globals.uniJson=value;
      globals.universities = json.decode(value);
    });

    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: OnBoardingPage(),
    );

  }
}

class OnBoardingPage extends StatelessWidget {

  const OnBoardingPage({Key key}) : super(key: key);


  void login(String username, String password, context) {


    RequestHelper.getTrainings(globals.universityUrl, username, password).then((value){
      try {
        Map<String, dynamic> response = json.decode(value);
        if (response["ErrorMessage"] == null) {
          globals.username = username;
          globals.password = password;
          globals.trainingId = response["TrainingList"][0]["Id"].toString();
          //print(globals.trainingId);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      }catch(e){
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Hiba:" + e.toString()),));
      }
    });

  }


  @override
  Widget build(BuildContext context) {

    const bodyStyle = TextStyle(fontSize: 19.0,color: Colors.white);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 56.0, 16.0, 16.0),
      pageColor: Colors.black,
      titlePadding: EdgeInsets.fromLTRB(20, 100, 20, 20)
      //imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "e-Pluto",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Ez egy nonprofit kliens a NEPTUN rendszerhez\n"
                  "\n"
                  "\nMivel nem az SDA Informatika Zrt. készítette ezért ne az ő ügyfélszolgálatukat terheld, hanem írj egy e-mailt az alkalmazás fejlesztőjének:\n"
                  "s4k11@tuta.io\n"
                  "\n"
                  "Az alkalmazás csak saját felelősségre használható", style: bodyStyle)
            ],
          ),
          // TODO image: _buildImage('img1'),
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
          log("valid");
          login(globals.usernameController.text, globals.passwordController.text,context);

        }else{
          log("invalid");
        }

      },
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipFlex: 0,
      nextFlex: 0,
      //skip: const Text('Skip'),
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



