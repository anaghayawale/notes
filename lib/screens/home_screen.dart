import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Constants.appBackgroundColor,
      appBar: AppBar(
        surfaceTintColor: Constants.yellowColor,
        title: Text(
          "Notes",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Constants.yellowColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Text('Welcome to ${userProvider.user.name}\'s notes'),
        ],
      ),
    );
  }
}