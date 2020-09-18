import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:e_pluto/RequestHelper.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';

class MessagesFragment extends StatefulWidget {
  @override
  _MessagesFragmentState createState() => new _MessagesFragmentState();
}

class Message {
  String sender, subject, body;
  bool isNew;

  Message(String sender, String subject, String body, bool isNew) {
    this.subject = subject;
    this.body = body;
    this.sender = sender;
    this.isNew = isNew ?? true;
  }
}

class _MessagesFragmentState extends State<MessagesFragment> {
  List<Message> messages = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      refreshKey.currentState?.show();
    });
  }

  Future<void> reloadMessages() async {
    String response = await RequestHelper.getMessages();
    response = response.trim();
    var messagesJson;
    try {
      messagesJson = json.decode(response);
      setState(() {
        messages.clear();
      });

      for (int i = 0; i < messagesJson["MessagesList"].length; i++) {
        var msg = new Message(messagesJson["MessagesList"][i]["Name"], messagesJson["MessagesList"][i]["Subject"], messagesJson["MessagesList"][i]["Detail"],
            messagesJson["MessagesList"][i]["IsNew"]);
        setState(() {
          messages.add(msg);
          loading=false;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildAboutDialog(BuildContext context, String title, String text) {
    text = text.replaceAll("\r\n  ", "\r\n ").replaceAll("\r\n ", "\r\n").replaceAll("\r\n", "<br>");
    String markdown = html2md.convert(text);
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 10, right: 10),

      title: Center(
          child: Padding(
        child: Text(title),
        padding: EdgeInsets.only(bottom: 20),
      )),
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
            /*child: */ Container(
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

  void showMessage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildAboutDialog(context, messages[index].subject, messages[index].body),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> msgWidget = [];

    msgWidget.clear();
    if (messages == null || messages.isEmpty) {
      if(!loading) {
        msgWidget.add(new ListTile(title: Text("Nincs több üzenet")));
      }
    }else {
      for (int i = 0; i < messages.length; i++) {
        msgWidget.add(ListTile(
          leading: Icon(messages[i].isNew ? Icons.mail : Icons.drafts),
          title: Text(messages[i].subject),
          onTap: () => showMessage(i),
        ));
      }
    }

    return RefreshIndicator(
      key: refreshKey,
      child: ListView.builder(
        itemCount: msgWidget?.length,
        itemBuilder: (context, i) => msgWidget[i],
      ),
      onRefresh: () => reloadMessages(),
    );
  }
}
