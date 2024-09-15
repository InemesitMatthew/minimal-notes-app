import 'package:flutter/material.dart';

class NoteDialogs {
  // Show dialog for creating a new note
  static void showCreateDialog({
    required BuildContext context,
    required TextEditingController textController,
    required VoidCallback onCreate, // Callback for creating the note
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface, // Dialog background color
        content: TextField(
          controller: textController, // Controller for note input
          decoration: const InputDecoration(hintText: 'Enter note text'), // Placeholder text
        ),
        actions: [
          // Button to create the note
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // If the note is empty, show a SnackBar message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return; // Don't proceed if the input is empty
              }
              onCreate(); // Trigger the note creation callback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note created successfully')),
              );
              textController.clear(); // Clear the input field
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Create"), // Label for the create button
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
        title: const Text("Update Note"), // Title of the dialog
        content: TextField(controller: textController), // Pre-filled text field with the note text
        actions: [
          // Button to update the note
          MaterialButton(
            onPressed: () {
              if (textController.text.trim().isEmpty) {
                // Show error message if the note is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Note cannot be empty')),
                );
                return; // Don't proceed if the input is empty
              }
              onUpdate(); // Trigger the note update callback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note updated successfully')),
              );
              textController.clear(); // Clear the input field
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Update"), // Label for the update button
          ),
        ],
      ),
    );
  }

  // Show dialog for confirming note deletion
  static void showDeleteConfirmation({
    required BuildContext context,
    required VoidCallback onDelete, // Callback for deleting the note
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Note"), // Title for the delete confirmation
        content: const Text("Are you sure you want to delete this note?"), // Warning message
        actions: [
          // Cancel button to close the dialog without deleting
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog on cancel
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary, // Styled to match the theme
            ),
            child: const Text("Cancel"), // Label for the cancel button
          ),
          // Delete button to confirm deletion
          TextButton(
            onPressed: () {
              onDelete(); // Trigger the delete callback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted successfully')),
              );
              Navigator.pop(context); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error, // Styled for delete action
            ),
            child: const Text("Delete"), // Label for the delete button
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface, // Dialog background color
      ),
    );
  }
}
