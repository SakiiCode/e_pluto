import 'package:flutter/material.dart';
import 'package:e_pluto/globals.dart' as globals;

// Define a custom Form widget.
class LoginForm extends StatefulWidget {

  @override
  LoginFormState createState() {
    return LoginFormState();
  }



}

class LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();




  String validate(value){
    if (value.isEmpty) {
      return 'Nem adtál meg adatot';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    globals.loginFormKey=_formKey;
    globals.usernameController=TextEditingController();
    globals.passwordController=TextEditingController();
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              labelText: "NEPTUN-kód",
              border: OutlineInputBorder(),
            ),
            validator: (value) => validate(value),
            controller: globals.usernameController,
          ),
          SizedBox(height: 30),
          TextFormField(
            decoration: const InputDecoration(
              labelText: "Jelszó",
              border: OutlineInputBorder(),
            ),
            validator: (value) => validate(value),
            controller: globals.passwordController,
            obscureText: true,
          ),
        ]
      )
    );
  }

  @override
  void dispose() {
    globals.usernameController.dispose();
    globals.passwordController.dispose();
    super.dispose();
  }
}
