import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'note_settings.dart';

class NoteTile extends StatelessWidget {
  // Text content of the note
  final String text;
  // Callback for the edit button
  final void Function()? onEditPressed;
  // Callback for the delete button
  final void Function()? onDeletePressed;

  const NoteTile({
    super.key,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set background color and border radius for note tile
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(
        top: 10,
        left: 25,
        right: 25,
      ),
      child: ListTile(
        // Display the note text
        title: Text(text),
        // Show options (edit, delete) on pressing the trailing icon
        trailing: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => showPopover(
              width: 100,
              height: 100,
              backgroundColor: Theme.of(context).colorScheme.surface,
              context: context,
              bodyBuilder: (context) => NoteSettings(
                onEditTap: onEditPressed,
                onDeleteTap: onDeletePressed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
