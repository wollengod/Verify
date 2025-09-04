import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Themes/theme_provider.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.themeMode == ThemeMode.dark;

    return Row(
      children: [
        const Icon(Icons.light_mode, size: 20),
        Switch(
          value: isDark,
          onChanged: (value) {
            if (value) {
              themeProvider.setDarkTheme();
            } else {
              themeProvider.setLightTheme();
            }
          },
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.shade300,
        ),
        const Icon(Icons.dark_mode, size: 20),
      ],
    );
  }
}
