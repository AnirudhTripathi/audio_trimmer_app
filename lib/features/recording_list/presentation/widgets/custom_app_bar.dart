import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Icon(
        Icons.keyboard_arrow_left_rounded,
        size: 50,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.w800, fontSize: 25),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
