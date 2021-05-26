part of 'chatroom_bloc.dart';

abstract class ChatroomEvent extends Equatable {
  const ChatroomEvent();

  @override
  List<Object> get props => [];
}

class StartChatroomCommand extends ChatroomEvent {
  final String userId;
  final String chatroomName;

  StartChatroomCommand({this.userId, this.chatroomName});

  @override
  List<Object> get props => [userId, chatroomName];
}

class MessageUpdateEvent extends ChatroomEvent {
  final String message;

  MessageUpdateEvent(this.message);

  @override
  List<Object> get props => [message];
}

class SendMessageCommand extends ChatroomEvent {
  final String message;

  SendMessageCommand(this.message);

  @override
  List<Object> get props => [message];
}

class EndChatroom extends ChatroomEvent {}
