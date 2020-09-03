import 'package:e_pluto/RequestHelper.dart';
import 'package:e_pluto/LoginPages.dart';
import 'package:flutter/material.dart';

class LogoutFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    clearStorage(context);
    return new Center(
      child: new Text("Hamarosan"),
    );
  }

  void clearStorage(context) async {
    await RequestHelper.storage.deleteAll();
    print("Deleted user data");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPages()),
    );
    //Navigator.pop(context);
  }
}
