import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notes/providers/loading_provider.dart';
import 'package:notes/providers/user_provider.dart';
import 'package:notes/screens/sign_in_screen.dart';
import 'package:notes/utils/constants.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => LoadingProvider()),
    ],
    child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Constants.yellowColor,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Constants.yellowColor,
          selectionColor: Constants.yellowColor.withOpacity(0.5),
          selectionHandleColor: Constants.yellowColor,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.yellowColor),
        useMaterial3: true,
      ),
      home: const SignInScreen(),
    );
  }
}

