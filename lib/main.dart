

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_clone/core/http_certificate_manager.dart';

import 'package:flutter_chatgpt_clone/features/chat/presentation/cubit/chat_conversation/chat_conversation_cubit.dart';

import 'features/chat/presentation/pages/conversation_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
   await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => di.sl<ChatConversationCubit>(),
        child: MaterialApp(
          title: 'chat',
          theme: ThemeData(brightness: Brightness.dark),
          // initialRoute: '/',
          debugShowCheckedModeBanner: false,
          // onGenerateRoute: OnGenerateRoute.route,
          //  initialRoute: "/",
          home: ConversationPage(),
          // routes: {
          //   "/": (context) => ConversationPage()

          //   // add dark and light theme.
          //   // chatMessages history
          // },
        ));
  }
}
