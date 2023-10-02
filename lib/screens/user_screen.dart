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
      appBar: AppBar(
        title: Text(
          widget.user.name,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                iconSize: 16.0,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coins: ${widget.user.coins}',
              style: const TextStyle(fontSize: 24.0),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.user.coins--;
                });
              },
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.black), // 背景色を黒に設定
              ),
              child: const Text(
                'Decrease Coins',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
