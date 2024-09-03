class User {
  String name, email, password;

  User({required this.name, required this.email, required this.password});

  User.fromJson(Map<String, dynamic> json): 
    name = json['Name'],
    email = json['Email'],
    password = json['Password'];
}