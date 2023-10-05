import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isAdmin = false;
  String password = '1010';
  bool isDecreasing = false; // ボタンが押されているかどうかを判定するフラグ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'しんぷるコイン',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('ホ ー ム'),
              onTap: () {
                setState(() {
                  isAdmin = false;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('管 理 画 面'),
              onTap: () async {
                await _showPasswordDialog();
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: buildFirestoreUserScreen(),
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

  // Firestoreからデータを取得して表示するWidget

  Widget buildFirestoreUserScreen() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<User> users = snapshot.data!.docs.map((doc) {
          return User.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(users[index].name),
                subtitle: Text('Coins: ${users[index].coins}'),
                trailing: ElevatedButton(
                  onPressed: isDecreasing
                      ? null
                      : () async {
                          // ボタンが押されている場合は無効化
                          setState(() {
                            isDecreasing = true; // ボタンが押された状態にする
                          });
                          try {
                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              DocumentSnapshot snapshot = await transaction.get(
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(users[index].id));
                              if (snapshot.exists) {
                                int newCoins = snapshot.get('coins') - 1;
                                transaction.update(
                                    snapshot.reference, {'coins': newCoins});
                              }
                            });
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('An error occurred: $e')),
                            );
                          } finally {
                            setState(() {
                              isDecreasing = false; // ボタンが押された状態を解除
                            });
                          }
                        },
                  child: const Text('Decrease'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
