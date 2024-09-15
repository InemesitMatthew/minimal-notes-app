import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final bool isSearching; // Indicates if search mode is active
  final TextEditingController searchController; // Controller to capture search input
  final Function(String) onSearchChanged; // Callback to handle changes in search input
  final VoidCallback onSearchClose; // Callback to handle closing of search mode

  const CustomSearchBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClose,
  });

  @override
  Widget build(BuildContext context) {
    // If `isSearching` is true, display the search bar, else show an empty widget (avoiding any placeholder text).
    return isSearching
        ? TextField(
            controller: searchController, // Text controller for the search bar
            autofocus: true, // Automatically focus on the search input
            decoration: InputDecoration(
              hintText: 'Search notes...', // Placeholder text inside the search bar
              border: InputBorder.none, // No border to maintain a clean UI
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary, // Hint text color matching the theme
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary), // Input text color
            onChanged: onSearchChanged, // Trigger callback when search input changes
          )
        : const SizedBox.shrink(); // If not searching, return an empty widget to avoid UI clutter
  }
}
