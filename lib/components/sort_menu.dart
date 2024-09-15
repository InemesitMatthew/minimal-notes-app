import 'package:flutter/material.dart';
import '/models/note_db.dart';
import 'package:provider/provider.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the NoteDb provider to manage the current sorting state
    final noteDb = context.watch<NoteDb>();

    return PopupMenuButton<SortOrder>(
      icon: Icon(Icons.sort_rounded, color: Theme.of(context).colorScheme.inversePrimary), // Sort icon
      onSelected: (SortOrder selectedSortOrder) {
        // Update the sorting order in the NoteDb provider based on user selection
        noteDb.currentSortOrder = selectedSortOrder;
      },
      itemBuilder: (context) => [
        // PopupMenuItem for 'Newest First' with a checkmark if currently selected
        PopupMenuItem(
          value: SortOrder.newestFirst,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Newest First'), // Label for sorting by newest first
              if (noteDb.currentSortOrder == SortOrder.newestFirst)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary), // Checkmark if selected
            ],
          ),
        ),
        // PopupMenuItem for 'Oldest First'
        PopupMenuItem(
          value: SortOrder.oldestFirst,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Oldest First'), // Label for sorting by oldest first
              if (noteDb.currentSortOrder == SortOrder.oldestFirst)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary), // Checkmark if selected
            ],
          ),
        ),
        // PopupMenuItem for 'A-Z'
        PopupMenuItem(
          value: SortOrder.alphabeticalAZ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('A-Z'), // Label for alphabetical sorting (A-Z)
              if (noteDb.currentSortOrder == SortOrder.alphabeticalAZ)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary), // Checkmark if selected
            ],
          ),
        ),
        // PopupMenuItem for 'Z-A'
        PopupMenuItem(
          value: SortOrder.alphabeticalZA,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Z-A'), // Label for alphabetical sorting (Z-A)
              if (noteDb.currentSortOrder == SortOrder.alphabeticalZA)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary), // Checkmark if selected
            ],
          ),
        ),
      ],
    );
  }
}
