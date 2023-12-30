import 'package:flutter/material.dart';
import 'package:notes/utils/constants.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const CustomSearchBar({super.key, required this.onChanged});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return TextField(
      scrollPhysics: const NeverScrollableScrollPhysics(),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Constants.greyColor,
        hintText: "Search",
        hintStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Constants.greyTextColor,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: Constants.blackColor,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
