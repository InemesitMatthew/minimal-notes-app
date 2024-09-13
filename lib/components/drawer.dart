import 'package:flutter/material.dart';
import '/components/drawer_tile.dart';
import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Set the background color for the drawer
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Drawer header (icon with customized theme)
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent),
            ),
            child: const DrawerHeader(
              child: Icon(Icons.edit_outlined),
            ),
          ),

          const SizedBox(height: 25),

          // "Notes" tile to navigate to home page
          DrawerTile(
            title: "Notes",
            leading: const Icon(Icons.home_rounded),
            onTap: () => Navigator.pop(context),  // Close drawer on tap
          ),

          // "Settings" tile to navigate to settings page
          DrawerTile(
            title: "Settings",
            leading: const Icon(Icons.settings),
            onTap: () {
              // Close drawer and navigate to SettingsPage
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
