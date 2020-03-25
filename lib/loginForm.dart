import 'package:flutter/material.dart';
import 'package:e_pluto/globals.dart' as globals;

// Define a custom Form widget.
class LoginForm extends StatefulWidget {

  @override
  LoginFormState createState() {
    return LoginFormState();
  }



}

// Define a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();




  String validate(value){
    if (value.isEmpty) {
      return 'Nem adtál meg adatot';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
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
    // Clean up the controller when the widget is disposed.
    globals.usernameController.dispose();
    globals.passwordController.dispose();
    super.dispose();
  }
}
