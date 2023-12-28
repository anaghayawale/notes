import 'package:flutter/material.dart';
import 'package:notes/components/custom_dialog_box.dart';
import 'package:notes/screens/sign_in_screen.dart';
import 'package:notes/utils/constants.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  void logoutUser() {
    showDialog(
      context: context,
      builder: (context) {
        return const CustomDialogBox(
          title: 'Logout',
          content: 'Are you sure you want to logout?',
          actionButtonText: 'Logout',
          dialogType: DialogType.logout,
        );
      },
    ).then((value) => Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const SignInScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Constants.yellowColor,
          ),
          child: Icon(
            Icons.account_circle,
            size: 100.0,
            color: Constants.whiteColor,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Constants.yellowColor,
          ),
          title: Text('Logout',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Constants.yellowColor,
              )),
          onTap: logoutUser,
        ),
      ],
    ));
  }
}
