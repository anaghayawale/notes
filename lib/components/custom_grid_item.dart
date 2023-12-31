// custom_grid_item.dart
import 'package:flutter/material.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:notes/models/note.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/utils/constants.dart';
import 'package:provider/provider.dart';

class CustomGridItem extends StatelessWidget {
  final Note currentNote;
  final Function() onTap;
  final Function() onLongPress;
  final Function() inkwellOnTap;

  const CustomGridItem({
    super.key,
    required this.currentNote,
    required this.onTap,
    required this.onLongPress,
    required this.inkwellOnTap,
  });

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    int noteIndex = notesProvider.notes.indexOf(currentNote);
    Color decorationColor =
        Constants.noteColors[noteIndex % Constants.noteColors.length];

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedGradientBorder(
        gradientColors: [
          Constants.whiteColor,
          Constants.whiteColor,
          Constants.whiteColor,
          ((currentNote.id == notesProvider.animatedNoteId &&
                      notesProvider.animatedBorder == true) ||
                  (notesProvider.animatedDeleteNoteIds
                          .contains(currentNote.id) &&
                      notesProvider.animatedBorder == true))
              ? Constants.lightBlackColor
              : Constants.whiteColor,
        ],
        borderRadius: BorderRadius.circular(20.0),
        borderSize: 0.05,
        glowSize: 0.05,
        animationProgress: ((currentNote.id == notesProvider.animatedNoteId &&
                    notesProvider.animatedBorder == true) ||
                (notesProvider.animatedDeleteNoteIds.contains(currentNote.id) &&
                    notesProvider.animatedBorder == true))
            ? null
            : 0.1,
        child: Container(
          height: 220.0,
          width: 200.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          padding: const EdgeInsets.fromLTRB(10.0, 12.0, 10.0, 12.0),
          decoration: BoxDecoration(
            color: decorationColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentNote.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Constants.blackColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 7.0,
                  ),
                  Text(
                    currentNote.content,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Constants.greyTextColor,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
              if (notesProvider.isSelectionMode == true)
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: inkwellOnTap,
                        child: (currentNote.isSelected == true)
                            ? Icon(Icons.check_circle,
                                color: Constants.blackColor)
                            : Icon(Icons.circle_outlined,
                                color: Constants.blackColor),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
