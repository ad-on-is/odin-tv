class User {
  String username;
  String name;
  String avatar;
  bool vip;
  String id;
  DateTime? expiration;

  User(
      {this.username = '',
      this.name = '',
      this.id = '',
      this.vip = false,
      this.avatar = '',
      this.expiration});

  Map<String, dynamic> toJSon() => {
        'name': name,
        'username': username,
        'vip': vip,
        'id': id,
        'avatar': avatar,
      };

  factory User.fromTrakt(dynamic json) {
    return User(
        id: json['user']['ids']['uuid'] ?? '',
        username: json['user']['username'] ?? '',
        name: json['user']['name'] ?? '',
        vip: json['user']['vip'] ?? false,
        avatar: json['user']['images']['avatar']['full'] ?? '');
  }
  factory User.fromRealDebrid(dynamic json) {
    return User(
        username: json['username'] ?? '',
        avatar: json['avatar'] ?? '',
        vip: json['type'] == 'premium',
        expiration: DateTime.parse(json['expiration']));
  }
  factory User.fromJson(dynamic json) {
    return User(
        name: json['name'],
        id: json['id'],
        username: json['username'],
        avatar: json['avatar'],
        vip: json['vip']);
  }
}
