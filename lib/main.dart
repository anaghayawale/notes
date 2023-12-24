import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:notes/providers/loading_provider.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/user_provider.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:notes/screens/sign_in_screen.dart';
import 'package:notes/utils/constants.dart';
import 'package:notes/utils/token_storage.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => LoadingProvider()),
          ChangeNotifierProvider(create: (context) => NotesProvider()),
        ],
        child: MaterialApp(
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
          home: const MyAppInitializer(),
        ));
  }
}

class MyAppInitializer extends StatelessWidget {
  const MyAppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Check for the presence of a token
      future: _checkForToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Navigate to the appropriate screen based on the token
          return snapshot.hasData ? const HomeScreen() : const SignInScreen();
        } else {
          // Placeholder widget while checking for the token
          return Scaffold(
            body: Center(child: CircularProgressIndicator(
              color: Constants.yellowColor,
            )),
          );
        }
      },
    );
  }

  // Function to check for the presence of a token
  Future<bool> _checkForToken() async {
    String? token = await TokenStorage.retrieveToken();
    return token != null;
  }
}