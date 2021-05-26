import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/chatroom/chatroom_bloc.dart';
import 'package:livingston_hearing_aid_mobile/data/repositories/auth_repository.dart';
import 'package:livingston_hearing_aid_mobile/helpers/material_color_generator.dart';
import 'package:livingston_hearing_aid_mobile/presentation/pages/chat/chat_page.dart';

import 'business_logic/authentication/authentication_bloc.dart';
import 'presentation/pages/home/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await Firebase.initializeApp();
  runApp(MyApp(
    app: app,
  ));
}

class Application {
  static FluroRouter router;
}

class MyApp extends StatelessWidget {
  MyApp({this.app}) {
    final router = FluroRouter();
    router.define("/", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return LoginPage();
    }));

    router.define("/Chat", handler: Handler(
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      return ChatPage();
    }));

    Application.router = router;
  }

  final FirebaseApp app;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthenticationRepository(app),
        ),
        RepositoryProvider(
          create: (context) => ChatRepository(),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<AuthenticationBloc>(
              create: (BuildContext context) => AuthenticationBloc(
                  authenticationRepo: context.read<AuthenticationRepository>()),
            ),
            BlocProvider<ChatroomBloc>(
                create: (BuildContext context) => ChatroomBloc(
                    chatRepository: context.read<ChatRepository>())),
          ],
          child: MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: createMaterialColor(Color(0xFF026a71)),
              ),
              onGenerateRoute: Application.router.generator)),
    );
  }
}
