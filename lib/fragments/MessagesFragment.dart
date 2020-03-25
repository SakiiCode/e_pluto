import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:e_pluto/RequestHelper.dart';
import 'package:e_pluto/globals.dart' as globals;
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';


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
    var messagesJson = json.decode(response);
    globals.messages.clear();
    for(int i=0;i<messagesJson["MessagesList"].length;i++){
      var msg = messagesJson["MessagesList"][i];
      globals.messages.add(msg);
    }
  }

  Future<Null> refreshList() async {
    //refreshKey.currentState?.show(atTop: false); TODO ez kell?
    //await Future.delayed(Duration(seconds: 2)); TODO ez kell?
    reloadMessages();
    setState(() {
      msgWidget.clear();
      if(globals.messages==null || globals.messages.isEmpty){
        msgWidget.add(new ListTile(title:Text("Nincs több üzenet")));
      }
      for(int i=0;i<globals.messages.length;i++){

        msgWidget.add(ListTile(
          leading: Icon(globals.messages[i]["IsNew"]?Icons.mail:Icons.drafts),
          title: Text(globals.messages[i]["Subject"]),
          onTap: ()=>showMessage(i),
        ));
      }
    });

    return null;
  }


    Widget _buildAboutDialog(BuildContext context,String title,String text) {
      text=text.replaceAll("\r\n  ", "\r\n ").replaceAll("\r\n ", "\r\n").replaceAll("\r\n", "<br>");
      String markdown = html2md.convert(text);
      return AlertDialog(

        contentPadding: EdgeInsets.only(left: 10, right: 10),
        
        title: Center(child: Padding(child: Text(title), padding: EdgeInsets.only(bottom: 20),)),
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          /*height: 200,
          width: 300,*/
          //width: MediaQuery.of(context).size.width * 1.3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                //new HtmlView(data: text)//Text(text)
                new MarkdownBody(
                  data: markdown, //TODO a linkek nem működnek
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Padding(
                //padding: const EdgeInsets.only(right: 70.0),
                /*child: */Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  child: RaisedButton(
                    child: new Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xFF121A21),
                    /*shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),*/
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              //),
              /*SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),*/
            ],
          )
        ],
      );
    }

    void showMessage(int index){
      showDialog(
          context: context,
          builder: (BuildContext context) => _buildAboutDialog(context,globals.messages[index]["Subject"],globals.messages[index]["Detail"]),
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