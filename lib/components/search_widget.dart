import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final bool isSearching; // Indicates if the search mode is active
  final TextEditingController searchController; // Search text controller
  final Function(String) onSearchChanged; // Callback when search query changes
  final VoidCallback onSearchClose; // Callback to close search mode

  const CustomSearchBar({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.onSearchChanged,
    required this.onSearchClose,
  });

  @override
  Widget build(BuildContext context) {
    // Return search bar when in search mode, otherwise just an empty widget (no text UI)
    return isSearching
        ? TextField(
            controller: searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search notes...', // Placeholder text
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
            onChanged: onSearchChanged, // Trigger on search input change
          )
        : const SizedBox(); // Empty widget instead of Text('') for cleaner UI
  }
}
