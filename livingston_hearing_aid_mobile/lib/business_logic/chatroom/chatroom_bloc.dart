import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/io.dart';

part 'chatroom_event.dart';
part 'chatroom_state.dart';

class ChatroomBloc extends Bloc<ChatroomEvent, ChatroomState> {
  ChatroomBloc({@required this.chatRepository})
      : super(ChatroomState(messages: [], status: ChatroomStatus.offline));

  final IChatRepository chatRepository;
  StreamSubscription _messageSubscription;

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<ChatroomState> mapEventToState(
    ChatroomEvent event,
  ) async* {
    if (event is StartChatroomCommand) {
      await _messageSubscription?.cancel();
      _messageSubscription = chatRepository.initializeRoom().listen((event) {
        add(MessageUpdateEvent(event));
      });

      if (state.status == ChatroomStatus.offline)
        yield state.copyWith(status: ChatroomStatus.online);
    } else if (event is MessageUpdateEvent) {
      var currentList = state.messages.toList();
      currentList.add(event.message);
      yield state.copyWith(messages: currentList);
    } else if (event is SendMessageCommand) {
      chatRepository.addMessage(event.message);
    } else if (event is EndChatroom) {
      await chatRepository.cancelStream();
      await _messageSubscription?.cancel();

      yield state.copyWith(status: ChatroomStatus.offline);
    }
  }
}

abstract class IChatRepository {
  Future<String> initializeChat({String chatRoomName, String userId});

  Stream initializeRoom();

  void addMessage(String message);

  Future cancelStream();
}

// WHEN workign with HTTP or Websockets see this config
//https://stackoverflow.com/questions/64197752/bad-state-insecure-http-is-not-allowed-by-platform/65578828

class ChatRepository extends Disposable implements IChatRepository {
  IOWebSocketChannel channel;

  ChatRepository() {
    _messageController = StreamController.broadcast();
  }

  StreamController _messageController;

  @override
  Future<String> initializeChat({String chatRoomName, String userId}) {
    return Future.value(":");
  }

  @override
  cancelStream() async {
    await channel.sink.close();
  }

  @override
  Stream initializeRoom() {
    channel = IOWebSocketChannel.connect(Uri.parse('ws://10.0.2.2:3000'));

    return channel.stream.asBroadcastStream();
  }

  void addMessage(String message) async {
    channel.sink.add(message);
  }

  @override
  FutureOr onDispose() {
    _messageController.close();
  }
}
