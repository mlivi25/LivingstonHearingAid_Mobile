import 'package:flutter/material.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/authentication/authentication_bloc.dart';
import 'package:livingston_hearing_aid_mobile/presentation/shared_widgets/lha_text_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountDialog extends StatefulWidget {
  CreateAccountDialog({Key key}) : super(key: key);

  @override
  _CreateAccountDialogState createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  final _createAccountFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();

    _emailController.addListener(() {
      createAccountvalidationlistener();
    });
    super.initState();
  }

  void createAccountvalidationlistener() {
    _createAccountFormKey.currentState.validate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(50),
      title: Text(
        'Create an Account',
        style: TextStyle(fontSize: 30),
      ),
      children: [
        Form(
          key: _createAccountFormKey,
          child: Container(
            height: 280,
            width: 500,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                    hintText: 'Email',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: LHATextInput(
                    inputController: _passwordController,
                    hintText: 'New Password',
                    isPassword: true,
                  ),
                ),
                MaterialButton(
                    color: Theme.of(context).accentColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Create Account',
                          style: TextStyle(fontSize: 30, color: Colors.white)),
                    ),
                    onPressed: () {
                      context.read<AuthenticationBloc>().add(
                          CreateAccountCommand(
                              email: _emailController.text.trim(),
                              password: _passwordController.text));
                      Navigator.pop(context);
                    })
              ],
            ),
            // ),
          ),
        )
      ],
    );
  }
}
