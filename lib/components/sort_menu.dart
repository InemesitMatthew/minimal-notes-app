import 'package:flutter/material.dart';
import '/models/note_db.dart';
import 'package:provider/provider.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final noteDb = context.watch<NoteDb>();

    return PopupMenuButton<SortOrder>(
      icon: Icon(Icons.sort_rounded, color: Theme.of(context).colorScheme.inversePrimary),
      onSelected: (SortOrder selectedSortOrder) {
        // Update sorting order in the database
        noteDb.currentSortOrder = selectedSortOrder;
      },
      itemBuilder: (context) => [
        // Each sort option with a checkmark if selected
        PopupMenuItem(
          value: SortOrder.newestFirst,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Newest First'),
              if (noteDb.currentSortOrder == SortOrder.newestFirst)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary),
            ],
          ),
        ),
        PopupMenuItem(
          value: SortOrder.oldestFirst,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Oldest First'),
              if (noteDb.currentSortOrder == SortOrder.oldestFirst)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary),
            ],
          ),
        ),
        PopupMenuItem(
          value: SortOrder.alphabeticalAZ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('A-Z'),
              if (noteDb.currentSortOrder == SortOrder.alphabeticalAZ)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary),
            ],
          ),
        ),
        PopupMenuItem(
          value: SortOrder.alphabeticalZA,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Z-A'),
              if (noteDb.currentSortOrder == SortOrder.alphabeticalZA)
                Icon(Icons.check, color: Theme.of(context).colorScheme.inversePrimary),
            ],
          ),
        ),
      ],
    );
  }
}
