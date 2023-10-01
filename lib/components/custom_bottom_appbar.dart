import 'package:flutter/material.dart';

class CustomBottomAppBar extends StatelessWidget {
  final Function onUserPressed;
  final Function onAdminPressed;

  const CustomBottomAppBar(
      {super.key, required this.onUserPressed, required this.onAdminPressed});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // User Button
          ElevatedButton(
            onPressed: () => onUserPressed(),
            child: const Text('User'),
          ),
          // Admin Button
          ElevatedButton(
            onPressed: () => onAdminPressed(),
            child: const Text('Admin'),
          ),
        ],
      ),
    );
  }
}
