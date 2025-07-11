import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Themes/theme_provider.dart';

class ThemeModeButton extends StatelessWidget {
  const ThemeModeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentMode = themeProvider.themeMode;

    IconData modeIcon = switch (currentMode) {
      ThemeMode.light => Icons.light_mode,
      ThemeMode.dark => Icons.dark_mode,
      _ => Icons.brightness_auto,
    };

    return PopupMenuButton<ThemeMode>(
      icon: Icon(
        modeIcon,
        color: Theme.of(context).iconTheme.color, // ✅ Automatically adapts
      ),
      onSelected: (ThemeMode mode) {
        switch (mode) {
          case ThemeMode.light:
            themeProvider.setLightTheme();
            break;
          case ThemeMode.dark:
            themeProvider.setDarkTheme();
            break;
          case ThemeMode.system:
            themeProvider.setSystemTheme();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.light,
          child: Row(
            children: const [Icon(Icons.light_mode), SizedBox(width: 8), Text("Light")],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: Row(
            children: const [Icon(Icons.dark_mode), SizedBox(width: 8), Text("Dark")],
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.system,
          child: Row(
            children: const [Icon(Icons.brightness_auto), SizedBox(width: 8), Text("System")],
          ),
        ),
      ],
    );
  }
}
