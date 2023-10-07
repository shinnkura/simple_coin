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
      body: isAdmin ? buildAdminScreen() : buildUserScreen(),
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

  // ユーザー画面を構築するメソッド
  Widget buildUserScreen() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
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
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot snapshot = await transaction.get(
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(users[index].id));
                        if (snapshot.exists) {
                          int newCoins = snapshot.get('coins') - 1;
                          transaction
                              .update(snapshot.reference, {'coins': newCoins});
                        }
                      });
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('An error occurred: $e')),
                      );
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

  // 管理画面を構築するメソッド
  Widget buildAdminScreen() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot doc = snapshot.data!.docs[index];
            return ListTile(
              title: Text(doc['name']),
              subtitle: Text('Coins: ${doc['coins']}'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(doc.id)
                      .update({'coins': doc['coins'] + 1});
                },
                child: const Text('Increase'),
              ),
            );
          },
        );
      },
    );
  }
}
