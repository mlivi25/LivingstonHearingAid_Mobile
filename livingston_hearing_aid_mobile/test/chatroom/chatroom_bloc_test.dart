import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:livingston_hearing_aid_mobile/business_logic/chatroom/chatroom_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

void main() {
  group('[ChatRoom_Bloc_Test]', () {
    ChatroomBloc sut;
    MockChatRepo mockChatRepo;
    StreamController _messageStreamController;

    setUp(() {
      mockChatRepo = MockChatRepo();
      _messageStreamController = StreamController();

      when(mockChatRepo.initializeRoom())
          .thenAnswer((_) => _messageStreamController.stream);

      when(mockChatRepo.initializeChat(
              chatRoomName: anyNamed('chatRoomName'),
              userId: anyNamed('userId')))
          .thenAnswer((_) => Future.value("Response"));

      when(mockChatRepo.addMessage(argThat(isA<String>()))).thenAnswer((_) {
        _messageStreamController.add("Test Message");
      });

      sut = new ChatroomBloc(chatRepository: mockChatRepo);
    });

    tearDown(() {
      _messageStreamController.close();
      sut.close();
    });

    test('Chatroom Bloc Initial State is Offline', () {
      expect(sut.state,
          ChatroomState(messages: [], status: ChatroomStatus.offline));
    });

    blocTest(
      'ChatroomStartEvent Begins chat',
      build: () => sut,
      act: (sut) {
        sut.add(StartChatroomCommand());
      },
      expect: () =>
          [ChatroomState(messages: [], status: ChatroomStatus.online)],
    );

    blocTest('NewMessageEvent',
        build: () => sut,
        act: (sut) {
          sut.add(StartChatroomCommand());
          _messageStreamController.add("Message Test");
        },
        expect: () => [
              ChatroomState(messages: [], status: ChatroomStatus.online),
              ChatroomState(
                  messages: ["Message Test"], status: ChatroomStatus.online)
            ]);

    blocTest('Send Message Event',
        build: () => sut,
        act: (sut) async {
          await sut.add(StartChatroomCommand());
          await sut.add(SendMessageCommand('message'));
        },
        expect: () => [
              ChatroomState(messages: [], status: ChatroomStatus.online),
              ChatroomState(
                  messages: ["Test Message"], status: ChatroomStatus.online)
            ]);

    blocTest('Unsubscribe resubscribe',
        build: () => sut,
        act: (sut) async {
          sut.add(StartChatroomCommand());
          sut.add(SendMessageCommand('message'));
          sut.add(EndChatroom());
        },
        wait: const Duration(milliseconds: 500),
        expect: () => [
              ChatroomState(messages: [], status: ChatroomStatus.online),
              ChatroomState(messages: [], status: ChatroomStatus.offline),
              ChatroomState(
                  messages: ["Test Message"], status: ChatroomStatus.offline)
            ]);
  });
}

class MockChatRepo extends Mock implements ChatRepository {}
