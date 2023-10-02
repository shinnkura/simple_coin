import 'package:flutter/material.dart';
import 'package:simple_coin/models/user.dart';

class UserScreen extends StatefulWidget {
  final User user;

  const UserScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.user.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Coins: ${widget.user.coins}'),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.user.coins--;
                });
              },
              child: const Text('Decrease Coins'),
            ),
          ],
        ),
      ),
    );
  }
}
