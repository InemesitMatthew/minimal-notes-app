import 'package:flutter/material.dart';

class NoteDialogs {
  // Show dialog to create a note
  static void showCreateDialog({
    required BuildContext context,
    required TextEditingController textController,
    required VoidCallback onCreate,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: 'Enter note text'),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Show feedback if the note is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              onCreate(); // Trigger note creation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note created successfully')),
              );
              textController.clear(); // Clear input field
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // Show dialog to update a note
  static void showUpdateDialog({
    required BuildContext context,
    required TextEditingController textController,
    required VoidCallback onUpdate,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text("Update Note"),
        content: TextField(controller: textController),
        actions: [
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Show feedback if note is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              onUpdate(); // Trigger note update
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note updated successfully')),
              );
              textController.clear(); // Clear input field
              Navigator.pop(context); // Close dialog
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // Show dialog to confirm note deletion
  static void showDeleteConfirmation({
    required BuildContext context,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Restore Cancel button color
            ),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onDelete(); // Trigger note deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
              Navigator.pop(context); // Close dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error, // Delete button color
            ),
            child: const Text("Delete"),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
    );
  }
}
