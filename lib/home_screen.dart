import 'package:flutter/material.dart';

import 'components/custom_bottom_appbar.dart';
import 'models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAdmin = false;
  String password = 'admin123';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User and Admin App')),
      body: isAdmin ? buildAdminScreen() : buildUserScreen(),
      bottomNavigationBar: CustomBottomAppBar(
        onUserPressed: () {
          setState(() {
            isAdmin = false;
          });
        },
        onAdminPressed: () async {
          // Admin ボタンが押されたときの処理
          await _showPasswordDialog();
        },
      ),
    );
  }

  Future<void> _showPasswordDialog() async {
    TextEditingController passwordController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Admin Password'),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (passwordController.text == password) {
                  setState(() {
                    isAdmin = true;
                  });
                } else {
                  // パスワードが間違っている場合の処理
                  // ここでは何もしない
                }
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // User Screen
  Widget buildUserScreen() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index].name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserScreen(user: users[index]),
              ),
            );
          },
        );
      },
    );
  }

  // Admin Screen
  Widget buildAdminScreen() {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(users[index].name),
          subtitle: Text('Coins: ${users[index].coins}'),
          onTap: () {
            setState(() {
              users[index].coins += 10;
            });
          },
        );
      },
    );
  }
}

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
