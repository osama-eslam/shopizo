import 'package:flutter/material.dart';
import 'package:image_picker_demo/ui/pages/theme/theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: isDark ? Colors.yellow : Colors.black,
      ),
      onPressed: () {
        final themeMode = isDark ? ThemeMode.light : ThemeMode.dark;

        MyAppTheme.of(context)?.setThemeMode(themeMode);
      },
    );
  }
}
