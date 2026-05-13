import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yummy/chat/support_chat_manager.dart';
import 'package:yummy/chat/support_chat_message.dart';
import 'package:yummy/chat/support_chat_repository.dart';

import 'support_chat_manager_mockito_test.mocks.dart';

@GenerateMocks([SupportChatRepository])
void main() {
  group('SupportChatManager with Mockito', () {
    test('delegates send and clears loading state on success', () async {
      final repository = MockSupportChatRepository();
      final manager = SupportChatManager(repository);

      when(repository.sendMessage('hello')).thenAnswer((_) async {});

      await manager.send('hello');

      verify(repository.sendMessage('hello')).called(1);
      expect(manager.sending, isFalse);
      expect(manager.error, isNull);
      manager.dispose();
    });

    test('captures repository failures as error text', () async {
      final repository = MockSupportChatRepository();
      final manager = SupportChatManager(repository);

      when(repository.sendMessage('help')).thenThrow(Exception('offline'));

      await manager.send('help');

      verify(repository.sendMessage('help')).called(1);
      expect(manager.sending, isFalse);
      expect(manager.error, contains('offline'));
      manager.dispose();
    });

    test('exposes repository message stream', () async {
      final repository = MockSupportChatRepository();
      final message = SupportChatMessage(
        senderId: 'u1',
        senderLabel: 'Member',
        text: 'Need help',
        createdAt: DateTime(2026, 1, 1, 9),
      );

      when(repository.watchMessages()).thenAnswer(
        (_) => Stream.value([message]),
      );

      final manager = SupportChatManager(repository);
      final messages = await manager.messageStream.first;

      verify(repository.watchMessages()).called(1);
      expect(messages.single.text, 'Need help');
      manager.dispose();
    });
  });
}
