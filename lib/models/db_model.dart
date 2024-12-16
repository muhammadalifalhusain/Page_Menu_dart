class User {
  int? id;
  String username;
  String password;

  User ({this.id, required this.username, required this.password});

  Map<String, dynamic> toMap(){
    return {'id': id, 'username': username, 'password': password};

  }
  User.fromMap(Map<String, dynamic> map)
    : id = map['id'],
    username = map['username'],
    password = map['password'];
}