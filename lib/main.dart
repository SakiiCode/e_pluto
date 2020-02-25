import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(), /* ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),*/
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: OnBoardingPage(),
    );

  }
}

class OnBoardingPage extends StatelessWidget {


  const OnBoardingPage({Key key}) : super(key: key);

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    /*return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );*/

    const bodyStyle = TextStyle(fontSize: 19.0,color: Colors.white);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.black,
      titlePadding: EdgeInsets.fromLTRB(20, 200, 20, 20)
      //imagePadding: EdgeInsets.zero,
    );



    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Ez egy nonprofit kliens a NEPTUN rendszerhez\n"
                  "\n"
                  "\nMivel nem az SDA Informatika Zrt. készítette ezért ne az ő ügyfélszolgálatukat terheld, hanem írj egy e-mailt az alkalmazás fejlesztőjének:\n"
                  "s4k11@tuta.io",style: bodyStyle)
            ],
          ),
          //image: _buildImage('img1'),
          decoration: pageDecoration,

        ),
        PageViewModel(
          title: "Egyetem választása",
          bodyWidget:UniversitiesList(),

          //image: _buildImage('img2'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Bejelentkezés",
          bodyWidget:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
  )                   new TextFormField(
                        style:
                        TextStyle(color: Colors.white),
                        controller: new TextEditingController(),
                        decoration: InputDecoration(
                          prefixIcon:
                          new Icon(Icons.person),
                          hintText: "NEPTUN kód",
                          hintStyle: TextStyle(
                              color: Colors.white30),
                          //errorText: "asd",
                          fillColor: Color.fromARGB(
                              40, 20, 20, 30),
                          filled: true,

                          contentPadding:
                          EdgeInsets.fromLTRB(
                              5.0, 15.0, 5.0, 15.0),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(
                                5.0),
                            gapPadding: 1.0,
                            borderSide: BorderSide(
                              color: Colors.green,
                              width: 2.0,
                            )
                          )
                        )
                      ),


                    ]

                  ),
                ]
              ),

            ]
          )
        ]
      ),

          //image: _buildImage('img3'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Another title page",
          body: "Another beautiful body text for this example onboarding",
          //image: _buildImage('img2'),
          footer: RaisedButton(
            onPressed: () {/* Nothing */},
            child: const Text(
              'FooButton',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Title of last page",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on ", style: bodyStyle),
              Icon(Icons.edit),
              Text(" to edit a post", style: bodyStyle),
            ],
          ),
          //image: _buildImage('img1'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
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

class UniversitiesList extends StatefulWidget{

  @override
  _UniversitiesListState createState() => _UniversitiesListState();

}

class _UniversitiesListState extends State<UniversitiesList> {

  List<DropdownMenuItem> items = [];
  String selectedValue;


  @override
  Widget build(BuildContext context) {
    items.clear();
    for(int i=0; i < 20; i++){
      items.add(new DropdownMenuItem(
        child: new Text(
          'test ' + i.toString(),
        ),
        value: 'test ' + i.toString(),
      ));
    }

    return new SearchableDropdown(
      items: items,
      value: selectedValue,
      hint: new Text(
          'Select One'
      ),
      searchHint: new Text(
        'Select One',
        style: new TextStyle(
            fontSize: 20
        ),
      ),
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}