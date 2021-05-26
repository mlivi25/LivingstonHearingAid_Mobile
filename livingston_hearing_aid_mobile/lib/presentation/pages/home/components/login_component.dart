import 'package:flutter/material.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/authentication/authentication_bloc.dart';
import 'package:livingston_hearing_aid_mobile/presentation/shared_widgets/lha_text_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_account_dialog.dart';

class LoginComponent extends StatefulWidget {
  @override
  _LoginComponentState createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  TextEditingController _emailController;

  TextEditingController _passwordController;

  final _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();

    _emailController.addListener(formValidation);
    super.initState();
  }

  formValidation() {
    _loginFormKey.currentState.validate();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Login', style: TextStyle(fontSize: 40)),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: LHATextInput(
              inputController: _emailController,
              validator: (value) {
                return (value == null ||
                        value.isEmpty ||
                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value))
                    ? 'Please enter valid email address'
                    : null;
              },
              hintText: 'Username',
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: LHATextInput(
              inputController: _passwordController,
              hintText: 'Password',
              isPassword: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sign-In',
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
                onPressed: () {
                  if (_loginFormKey.currentState.validate()) {
                    context.read<AuthenticationBloc>().add(EmailLoginCommand(
                        email: _emailController.text.trim(),
                        password: _passwordController.text));
                    _loginFormKey.currentState.reset();
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Create Account',
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => CreateAccountDialog())),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
                color: Theme.of(context).accentColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Sign-In with Google',
                      style: TextStyle(fontSize: 30, color: Colors.white)),
                ),
                onPressed: () => context
                    .read<AuthenticationBloc>()
                    .add(GoogleLoginCommand())),
          )
        ],
      ),
    );
  }
}
