class User {
  final String? id;
  final String firstName;
  final String lastName;
  final int age;
  final String? contactEmail;
  final int? phoneNumber;

  User(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.age,
      this.contactEmail,
      this.phoneNumber});

  Map<String, dynamic> toJson() => {
        '_id': id,
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'contact_email': contactEmail,
        'phone_number': phoneNumber
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['_id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      age: json['age'],
      contactEmail: json['contact_email'],
      phoneNumber: json['phone_number']);
}

class UserCredentials {
  String? id;
  String? userId;
  String email;
  String password;

  UserCredentials(
      {this.id, this.userId, required this.email, required this.password});

  Map<String, dynamic> toJson() =>
      {'_id': id, 'user_id': userId, 'email': email, 'password': password};

  factory UserCredentials.fromJson(Map<String, dynamic> json) =>
      UserCredentials(
          id: json['_id'],
          userId: json['user_id'],
          email: json['email'],
          password: json['password']);
}

class UserDataWithCredentials {
  final User user;
  final UserCredentials userCredentials;

  UserDataWithCredentials({required this.user, required this.userCredentials});

  Map<String, dynamic> toJson() =>
      {'user_data': user.toJson(), 'credentials': userCredentials.toJson()};

  factory UserDataWithCredentials.fromJson(Map<String, dynamic> json) =>
      UserDataWithCredentials(
          user: User.fromJson(json['user_data']),
          userCredentials: UserCredentials.fromJson(json['credentials']));
}
