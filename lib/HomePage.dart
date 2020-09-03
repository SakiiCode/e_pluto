import 'fragments/MessagesFragment.dart';
import 'fragments/TimetableFragment.dart';
import 'fragments/ExamsFragment.dart';
import 'fragments/LogoutFragment.dart';
import 'package:flutter/material.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Üzenetek", Icons.rss_feed),
    new DrawerItem("Órarend", Icons.calendar_today),
    new DrawerItem("Vizsgák", Icons.receipt),
    new DrawerItem("Kijelentkezés", Icons.exit_to_app)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new MessagesFragment();
      case 1:
        return new TimetableFragment();
      case 2:
        return new ExamsFragment();
      case 3:
        return new LogoutFragment();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      bool selected = i == _selectedDrawerIndex;
      var color = selected?Colors.lightBlue:Colors.white;
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon,color: color,),
            title: new Text(d.title,
              style: new TextStyle(color: color)
            ),
            selected: selected,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("John Doe"), accountEmail: null),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}