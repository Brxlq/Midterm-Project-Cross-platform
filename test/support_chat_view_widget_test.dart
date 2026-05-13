import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yummy/chat/support_chat_manager.dart';
import 'package:yummy/chat/support_chat_message.dart';
import 'package:yummy/chat/support_chat_repository.dart';
import 'package:yummy/screens/support_chat_page.dart';

void main() {
  testWidgets('SupportChatView shows empty state and sends text', (
    tester,
  ) async {
    final repository = _FakeSupportChatRepository();
    final manager = SupportChatManager(repository);
    addTearDown(manager.dispose);

    await tester.pumpWidget(_TestApp(manager: manager));
    await tester.pump();

    expect(
      find.text('No messages yet. Start the conversation.'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(SupportChatView.inputKey),
      'Need roadside help',
    );
    await tester.tap(find.byKey(SupportChatView.sendButtonKey));
    await tester.pumpAndSettle();

    expect(repository.sentTexts.single, 'Need roadside help');
    expect(find.text('Need roadside help'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byKey(SupportChatView.inputKey)).controller,
      isNotNull,
    );
  });

  testWidgets('SupportChatView shows sending indicator', (tester) async {
    final repository = _FakeSupportChatRepository();
    final completer = Completer<void>();
    repository.sendCompleter = completer;
    final manager = SupportChatManager(repository);
    addTearDown(manager.dispose);

    await tester.pumpWidget(_TestApp(manager: manager));
    await tester.enterText(find.byKey(SupportChatView.inputKey), 'hello');
    await tester.tap(find.byKey(SupportChatView.sendButtonKey));
    await tester.pump();

    expect(find.byKey(SupportChatView.loadingIndicatorKey), findsOneWidget);

    completer.complete();
    await tester.pumpAndSettle();

    expect(find.byKey(SupportChatView.loadingIndicatorKey), findsNothing);
  });

  testWidgets('SupportChatView displays manager errors', (tester) async {
    final repository = _FakeSupportChatRepository(sendError: 'offline');
    final manager = SupportChatManager(repository);
    addTearDown(manager.dispose);

    await tester.pumpWidget(_TestApp(manager: manager));
    await tester.enterText(find.byKey(SupportChatView.inputKey), 'hello');
    await tester.tap(find.byKey(SupportChatView.sendButtonKey));
    await tester.pumpAndSettle();

    expect(find.byKey(SupportChatView.errorTextKey), findsOneWidget);
    expect(find.textContaining('offline'), findsOneWidget);
  });
}

class _FakeSupportChatRepository implements SupportChatRepository {
  _FakeSupportChatRepository({this.sendError});

  final String? sendError;
  final List<String> sentTexts = [];
  final List<SupportChatMessage> _messages = [];
  final StreamController<List<SupportChatMessage>> _controller =
      StreamController<List<SupportChatMessage>>.broadcast();

  Completer<void>? sendCompleter;

  @override
  Future<void> sendMessage(String text) async {
    if (sendError != null) {
      throw Exception(sendError);
    }
    final completer = sendCompleter;
    if (completer != null) {
      await completer.future;
    }
    sentTexts.add(text);
    _messages.add(
      SupportChatMessage(
        senderId: 'u1',
        senderLabel: 'Member',
        text: text,
        createdAt: DateTime(2026, 1, 1, 12),
      ),
    );
    _controller.add(List.unmodifiable(_messages));
  }

  @override
  Stream<List<SupportChatMessage>> watchMessages() {
    Future<void>.microtask(() {
      if (!_controller.isClosed) {
        _controller.add(List.unmodifiable(_messages));
      }
    });
    return _controller.stream;
  }
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.manager});

  final SupportChatManager manager;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(body: SupportChatView(manager: manager)),
    );
  }
}
