import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/screens/add_new_note_screen.dart';
import 'package:notes/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2), 
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              height: 220.0,
              width: 200.0,
              margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
              decoration: BoxDecoration(
                color: Constants.whiteColor,
                borderRadius:BorderRadius.circular(20.0),
            ),
            );
          },),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.yellowColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        onPressed: () {
          Navigator.push(context, 
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => const AddNewNoteScreen(),),);
        },
        child: Icon(Icons.add, color: Constants.whiteColor),

      )
    );
  }
}