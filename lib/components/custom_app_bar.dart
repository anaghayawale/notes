import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/utils/constants.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isSelectionMode;
  final List<Note> selectedNotes;
  final Function() onSelectionClose;
  final Function() onMenuPressed;
  final Function() onDeletePressed;

  const CustomAppBar({
    super.key,
    required this.isSelectionMode,
    required this.selectedNotes,
    required this.onSelectionClose,
    required this.onMenuPressed,
    required this.onDeletePressed,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return AppBar(
      surfaceTintColor: Constants.yellowColor,
      title: (widget.isSelectionMode == true && widget.selectedNotes.isNotEmpty)
          ? (notesProvider.selectedNotes.isEmpty)
              ? Text("Select items",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Constants.blackColor,
                  ))
              : (widget.selectedNotes.length > 1)
                  ? Text("${widget.selectedNotes.length} items selected",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Constants.blackColor,
                      ))
                  : Text("${widget.selectedNotes.length} item selected",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Constants.blackColor,
                      ))
          : Text(
              "",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Constants.blackColor,
              ),
            ),
      backgroundColor: Constants.whiteColor,
      actions: [
        if (widget.selectedNotes.isNotEmpty)
          IconButton(
            onPressed: widget.onDeletePressed,
            icon: Icon(
              Icons.delete,
              color: Constants.redColor.withOpacity(0.5),
            ),
          ),
      ],
      leading: Builder(
        builder: (context) {
          if (widget.isSelectionMode) {
            return IconButton(
              onPressed: widget.onSelectionClose,
              icon: Icon(Icons.close, color: Constants.blackColor),
            );
          } else {
            return IconButton(
              onPressed: widget.onMenuPressed,
              icon: Icon(Icons.menu, color: Constants.blackColor),
            );
          }
        },
      ),
    );
  }
}
