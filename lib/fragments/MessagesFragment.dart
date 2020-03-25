import 'dart:convert';

import 'package:e_pluto/main.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:e_pluto/RequestHelper.dart';
import 'package:e_pluto/globals.dart' as globals;



class MessagesFragment extends StatefulWidget {
  @override
  _MessagesFragmentState createState() => new _MessagesFragmentState();
}

class _MessagesFragmentState extends State<MessagesFragment> {

  List<Widget> msgWidget= [];

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void reloadMessages() async{

    String response = await RequestHelper.getMessages(globals.universityUrl, globals.username, globals.password, globals.trainingId);
    var msgjson = json.decode(response);
    print(msgjson);
    messages.clear();
    for(int i=0;i<msgjson["MessagesList"].length;i++){
      var msg = msgjson["MessagesList"][i];
      messages.add(msg);
    }
  }

  Future<Null> refreshList() async {
    //refreshKey.currentState?.show(atTop: false); TODO ez kellhet
    //await Future.delayed(Duration(seconds: 2));
    reloadMessages();
    setState(() {
      msgWidget.clear();
      if(messages==null || messages.isEmpty){
        msgWidget.add(new ListTile(title:Text("Nincs több üzenet")));
      }
      for(int i=0;i<messages.length;i++){
        msgWidget.add(ListTile(
          leading: Icon(messages[i]["IsNew"]?Icons.mail:Icons.drafts),
          title: Text(messages[i]["Subject"]),
          onTap: ()=>showMessage(i),
        ));
      }
    });

    return null;
  }


    Widget _buildAboutDialog(BuildContext context,String title,String text) {
      return new AlertDialog(
        title: Text(title),
        content: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(text),
          ],
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('OK'),
          ),
        ],
      );
    }

    void showMessage(int index){
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildAboutDialog(context,messages[index]["Subject"],messages[index]["Detail"]),
      );
    }

  @override
  Widget build(BuildContext context) {


    return RefreshIndicator(
      key: refreshKey,
      child: ListView.builder(
        itemCount: msgWidget?.length,
        itemBuilder: (context, i) => msgWidget[i],
      ),
      onRefresh: refreshList,
    );
  }

}