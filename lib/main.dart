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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  dotenv.load(fileName: 'assets/.env');
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
              cursorColor: Constants.blackColor,
              selectionColor: Constants.blackColor.withOpacity(0.5),
              selectionHandleColor: Constants.blackColor,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: Constants.blackColor),
            fontFamily: 'RobotoSlab',
            textTheme: const TextTheme(
              titleLarge: TextStyle(
                fontSize: 30,
              ),
              titleMedium: TextStyle(
                fontSize: 20,
              ),
              titleSmall: TextStyle(
                fontSize: 18,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
              ),
            ),
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
      future: _checkForToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            ('Error: ${snapshot.error}');
            // Handle the error appropriately, e.g., show an error message.
            return Scaffold(
              body: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Constants.redColor),
                ),
              ),
            );
          } else {
            if (snapshot.hasData == false) {
              (snapshot.hasData);
              return const SignInScreen();
            } else {
              (snapshot.hasData);
              return const HomeScreen();
            }
          }
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Constants.yellowColor,
              ),
            ),
          );
        }
      },
    );
  }

  Future<bool> _checkForToken() async {
    try {
      String? token = await TokenStorage.retrieveToken();
      ('Retrieved Token: $token');
      if (token == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      ('Error retrieving token: $e');
      return false;
    }
  }
}
