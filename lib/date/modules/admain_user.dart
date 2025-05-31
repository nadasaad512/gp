class AdminUser {
  final String uid;
  final String email;
  final String name;
  final String phone;
  final String city;
  final String arae;
  final String desc;
  final String address;
  final String password;
  final String image;

  AdminUser(
      {required this.uid,
      required this.email,
      required this.name,
      required this.arae,
      required this.phone,
      required this.city,
      required this.desc,
      required this.address,
      required this.password,
      required this.image});

  factory AdminUser.fromMap(Map<String, dynamic> map) {
    return AdminUser(
        uid: map['uid'] ?? '',
        email: map['email'] ?? '',
        name: map['name'] ?? '',
        phone: map['phone'] ?? '',
        city: map['city'] ?? '',
        arae: map['arae'] ?? '',
        desc: map['dec'] ?? '',
        address: map['address'] ?? '',
        password: map['password'] ?? '',
        image: map['image'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'city': city,
      'arae': arae,
      'dec': desc,
      'address': address,
      'password': password,
      'image': image
    };
  }
}
