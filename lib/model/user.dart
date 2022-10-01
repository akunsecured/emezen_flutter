import './enums.dart';

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

class UserWrapper {
  final User? user;
  final UserCredentials? userCredentials;
  final UserWrapperType type;

  UserWrapper({this.user, this.userCredentials, required this.type});

  Map<String, dynamic> toJson() =>
      {'user_data': user?.toJson(), 'credentials': userCredentials?.toJson()};

  factory UserWrapper.fromJson(Map<String, dynamic> json) {
    User? user;
    if (json['user_data'] != null) {
      user = User.fromJson(json['user_data']);
    }

    UserCredentials? userCredentials;
    if (json['credentials'] != null) {
      userCredentials = UserCredentials.fromJson(json['credentials']);
    }

    late UserWrapperType type;

    if (user == null && userCredentials != null) {
      type = UserWrapperType.credentials;
    } else if (user != null && userCredentials == null) {
      type = UserWrapperType.userData;
    } else {
      type = UserWrapperType.userDataWithCredentials;
    }

    return UserWrapper(
        user: user, userCredentials: userCredentials, type: type);
  }
}
