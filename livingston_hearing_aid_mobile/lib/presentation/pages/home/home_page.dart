import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/authentication/authentication_bloc.dart';
import 'package:livingston_hearing_aid_mobile/main.dart';
import 'components/login_component.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Livingston Hearing Aid Service',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BlocConsumer<AuthenticationBloc, AuthenticationState>(
              listener: (context, authState) {
                if (authState is AuthenticationError)
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Error ${authState.errorMessage}')));
                else if (authState is LoggedOut)
                  Navigator.popUntil(context, (route) => route.isFirst);
              },
              builder: (context, state) {
                if (state is LoggedOut || state is AuthenticationError)
                  return LoginComponent();
                else if (state is Authenticated)
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                              child: Text('Sign Out',
                                  style: TextStyle(fontSize: 30)),
                              onPressed: () {
                                if (context.read<AuthenticationBloc>().state
                                    is Authenticated)
                                  context
                                      .read<AuthenticationBloc>()
                                      .add(LogOutCommand());
                              })),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                              child: Text('Chat Page',
                                  style: TextStyle(fontSize: 30)),
                              onPressed: () {
                                if (context.read<AuthenticationBloc>().state
                                    is Authenticated)
                                  Application.router
                                      .navigateTo(context, '/Chat');
                              })),
                    ],
                  ));
                else if (state is ProcessingAuthentication) {
                  return CircularProgressIndicator();
                } else
                  return Text('ERROR Please restart the app');
              },
            ),
          ],
        ),
      ),
    );
  }
}




                // return Column(
                //   children: [
                //     Image.network('${state.user.photoURL}'),
                //     Card(
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Text('Name:  ${state.user.displayName}'),
                //           Text('Email: ${state.user.email}'),
                //           Text('UId:   ${state.user.uid}'),
                //           MaterialButton(
                //               child: Text('Sign Out',
                //                   style: TextStyle(fontSize: 30)),
                //               onPressed: () {
                //                 if (context.read<AuthenticationBloc>().state
                //                     is Authenticated)
                //                   context
                //                       .read<AuthenticationBloc>()
                //                       .add(LogOutCommand());
                //               })
                //         ],
                //       ),
                //     )
                //   ],
                // );