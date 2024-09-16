import 'package:flutter/material.dart';

class NoteDialogs {
  // Show dialog for creating a new note
  static void showCreateDialog({
    required BuildContext context,
    required TextEditingController textController,
    required VoidCallback onCreate, // Callback for note creation
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface, // Dialog background color
        content: TextField(
          controller: textController, // Controller for the note input
          decoration: const InputDecoration(hintText: 'Enter note text'), // Input placeholder
        ),
        actions: [
          // Cancel button to close the dialog without creating a note
          TextButton(
            onPressed: () {
              textController.clear(); // Clear the text field when canceling
              Navigator.pop(context); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Color for Cancel button
            ),
            child: const Text("Cancel"), // Label for cancel button
          ),
          // Button to create the note
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Show SnackBar if the note is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              onCreate(); // Trigger note creation
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note created successfully')),
              );
              textController.clear(); // Clear the input field
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Create"), // Label for create button
          ),
        ],
      ),
    );
  }

  // Show dialog for updating an existing note
  static void showUpdateDialog({
    required BuildContext context,
    required TextEditingController textController,
    required VoidCallback onUpdate, // Callback for updating the note
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface, // Dialog background color
        title: const Text("Update Note"), // Dialog title
        content: TextField(controller: textController), // Pre-filled text field with note text
        actions: [
          // Cancel button to close the dialog without updating
          TextButton(
            onPressed: () {
              textController.clear(); // Clear the text field when canceling
              Navigator.pop(context); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Color for Cancel button
            ),
            child: const Text("Cancel"), // Label for cancel button
          ),
          // Button to update the note
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Show SnackBar if the note is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return;
              }
              onUpdate(); // Trigger note update
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note updated successfully')),
              );
              textController.clear(); // Clear the input field
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Update"), // Label for update button
          ),
        ],
      ),
    );
  }

  // Show dialog for confirming note deletion (no changes needed here)
  static void showDeleteConfirmation({
    required BuildContext context,
    required VoidCallback onDelete, // Callback for deleting the note
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"), // Title for delete confirmation
        content: const Text("Are you sure you want to delete this note?"), // Warning message
        actions: [
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog on cancel
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Styled to match the theme
            ),
            child: const Text("Cancel"), // Label for cancel button
          ),
          // Delete button
          TextButton(
            onPressed: () {
              onDelete(); // Trigger the delete callback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
              Navigator.pop(context); // Close the dialog after deletion
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error, // Styled for delete action
            ),
            child: const Text("Delete"), // Label for delete button
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface, // Dialog background color
      ),
    );
  }
}
