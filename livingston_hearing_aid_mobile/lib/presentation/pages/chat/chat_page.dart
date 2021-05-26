import 'package:flutter/material.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/authentication/authentication_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/chatroom/chatroom_bloc.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              final state = context.watch<ChatroomBloc>().state;

              return Text('${state.status.toString()}');
            }),
            Container(
              child: Text('Chat Page'),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                    child: Text('Sign Out', style: TextStyle(fontSize: 30)),
                    onPressed: () {
                      if (context.read<AuthenticationBloc>().state
                          is Authenticated) {
                        context.read<ChatroomBloc>().add(EndChatroom());
                        context.read<AuthenticationBloc>().add(LogOutCommand());
                      }
                    })),
            BlocBuilder<ChatroomBloc, ChatroomState>(
              builder: (context, state) {
                if (state.status == ChatroomStatus.online)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MaterialButton(
                          child: Text('Send Message'),
                          onPressed: () => context
                              .read<ChatroomBloc>()
                              .add(SendMessageCommand('Message'))),
                      Container(
                        height: 300,
                        child: Center(
                          child: ListView.builder(
                              shrinkWrap: false,
                              itemCount: state.messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Text(' ${state.messages[index]}');
                              }),
                        ),
                      ),
                    ],
                  );
                else
                  return Column(
                    children: [
                      Text('Offline'),
                      MaterialButton(
                          child: Text('Init Chatroom'),
                          onPressed: () => context.read<ChatroomBloc>().add(
                              StartChatroomCommand(
                                  userId: 'UserId', chatroomName: 'Chat'))),
                    ],
                  );
              },
            )
          ],
        ),
      ),
    );
  }
}
