class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String designation;
  final String profileImage;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.designation,
    required this.profileImage,
  });

  String get fullName {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return "$firstName $lastName";
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    } else {
      return "Your Name";
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['firstName'] ?? json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      designation: json['designation'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "designation": designation,
      "profileImage": profileImage,
    };
  }
}
