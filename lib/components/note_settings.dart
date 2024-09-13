import 'package:flutter/material.dart';

class NoteSettings extends StatelessWidget {
  // Callback for edit action
  final void Function()? onEditTap;
  // Callback for delete action
  final void Function()? onDeleteTap;

  const NoteSettings({
    super.key,
    this.onEditTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Edit option for note
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the popover
            if (onEditTap != null) onEditTap!(); // Trigger edit action
          },
          child: Container(
            height: 50,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        // Delete option for note
        GestureDetector(
          onTap: () {
            Navigator.pop(context); // Close the popover
            if (onDeleteTap != null) onDeleteTap!(); // Trigger delete action
          },
          child: Container(
            height: 50,
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
