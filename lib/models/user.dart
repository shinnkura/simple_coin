class User {
  String id; // idフィールドを追加
  String name;
  int coins;

  User(this.id, this.name, this.coins); // コンストラクタにidを追加

  User.fromMap(Map<String, dynamic> map, this.id) // idを追加
      : name = map['name'],
        coins = map['coins'];
}
