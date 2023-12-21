import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
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
          onTap: () {},
        ),
      ],
    ));
  }
}
