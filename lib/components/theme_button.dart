import 'package:flutter/material.dart';

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    Key? key,
    required this.changeThemeMode,
  }) : super(key: key);

  final Future<void> Function(bool useLightMode) changeThemeMode;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return IconButton(
      icon: isBright
          ? const Icon(Icons.dark_mode_outlined)
          : const Icon(Icons.light_mode_outlined),
      onPressed: () async => changeThemeMode(!isBright),
    );
  }
}
