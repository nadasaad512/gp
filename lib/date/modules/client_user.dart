class ClientUser {
  final String uid;
  final String email;
  final String name1;
  final String name2;
  final String phone;
  final String address;
  final String city;
  final String area;
  final String password;
  final String age;
  final String gender;

  ClientUser({
    required this.uid,
    required this.email,
    required this.address,
    required this.name1,
    required this.name2,
    required this.phone,
    required this.city,
    required this.area,
    required this.age,
    required this.gender,
    required this.password,
  });

  factory ClientUser.fromMap(Map<String, dynamic> map) {
    return ClientUser(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name1: map['name1'] ?? '',
      name2: map['name2'] ?? '',
      phone: map['phone'] ?? '',
      city: map['city'] ?? '',
      area: map['area'] ?? '',
      age: map['age'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name1': name1,
      'address': address,
      'name2': name2,
      'phone': phone,
      'city': city,
      'area': area,
      'age': age,
      'gender': gender,
      'password': password,
    };
  }
}
