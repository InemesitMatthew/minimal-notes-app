import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  // Title for the drawer item
  final String title;
  // Leading widget (usually an icon)
  final Widget leading;
  // Function to execute when the tile is tapped
  final void Function()? onTap;

  const DrawerTile({
    super.key,
    required this.title,
    required this.leading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        // Set the title text
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
        // Set the leading icon
        leading: leading,
        // Set the onTap function
        onTap: onTap,
      ),
    );
  }
}
