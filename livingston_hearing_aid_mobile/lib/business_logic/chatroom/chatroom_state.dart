part of 'chatroom_bloc.dart';

class ChatroomState extends Equatable {
  const ChatroomState({@required this.messages, @required this.status});

  final ChatroomStatus status;

  final List<String> messages;

  ChatroomState copyWith({List<String> messages, ChatroomStatus status}) {
    return new ChatroomState(
        messages: messages ?? this.messages.toList(),
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [messages, status];

  @override
  String toString() {
    return '${status.toString()} ${messages.toString()}';
  }
}

enum ChatroomStatus { online, offline }
