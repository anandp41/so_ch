import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'core/strings.dart';
import 'core/themedata.dart';
import 'models/message_model.dart';
import 'presentation/auth/bloc/authentication_bloc.dart';
import 'presentation/auth/screens/Login/login_screen.dart';
import 'presentation/auth/user_model/user_model.dart';
import 'presentation/home/chat/bloc/web_socket_bloc.dart';
import 'presentation/home/chat/screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  bool containsEncryptionKey =
      await secureStorage.containsKey(key: encryptionKeyString);
  if (!containsEncryptionKey) {
    var key = Hive.generateSecureKey();
    await secureStorage.write(
        key: encryptionKeyString, value: base64UrlEncode(key));
  }
  String? keyFromSecureStorage =
      await secureStorage.read(key: encryptionKeyString);
  var encryptionKey = base64Url.decode(keyFromSecureStorage!);

  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox(hiveAuthBoxName,
      encryptionCipher: HiveAesCipher(encryptionKey));
  await Hive.openBox<MessageModel>(hiveMessagesBox,
      encryptionCipher: HiveAesCipher(encryptionKey));
  await Hive.openBox<UserModel>(hiveUsersBox,
      encryptionCipher: HiveAesCipher(encryptionKey));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) =>
              AuthenticationBloc()..add(AppStarted()),
        ),
        BlocProvider<WebSocketBloc>(
          create: (context) {
            final authState =
                BlocProvider.of<AuthenticationBloc>(context).state;
            String loggedInEmail = '';
            if (authState is AuthenticationAuthenticated) {
              loggedInEmail = authState.email;
            }
            return WebSocketBloc(
              channel: WebSocketChannel.connect(
                Uri.parse('wss://echo.websocket.events/.ws'),
              ),
              loggedInEmail: loggedInEmail,
            );
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: defaultThemeData,
        home: const App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}