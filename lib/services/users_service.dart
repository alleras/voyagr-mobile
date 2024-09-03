import 'dart:convert';

import 'package:voyagr_mobile/models/user_model.dart';
import 'package:voyagr_mobile/services/base_api_service.dart';

class UserRegistrationResponse {
  String? errorMessage;
  User? user;

  UserRegistrationResponse({this.user, this.errorMessage});
}

class UsersService extends BaseApiService {
  Future<UserRegistrationResponse> createUser(String name, String email) async {
    final response = await client.post(
      Uri.parse('$endpoint/users/create_user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic> {
        'email': email,
        'name': name,
      })
    );

    if (response.statusCode == 409){
      return UserRegistrationResponse(user: null, errorMessage: 'A user with this email already exists.');
    }

    return UserRegistrationResponse(
      user: User.fromJson((jsonDecode(response.body) as Map<String, dynamic>)['data'])
    );
  }

  Future<void> deleteUser(String email) async {
    await client.delete(
      Uri.parse('$endpoint/users/$email'), 
      headers: defaultHeaders
    );
  }

  Future<void> changePassword(User user, String oldPassword, String newPassword) async {
    await client.post(
      Uri.parse('$endpoint/users/${user.email}/change_password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic> {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      })
    );
  }

  Future<User?> getUser(String email) async {
    final response = await client.get(
      Uri.parse('$endpoint/users/$email'), 
      headers: defaultHeaders
    );

    if (response.statusCode == 404){
      return null;
    }
    else if(response.statusCode != 200) {
      throw Exception('Error retrieving User.');
    }
    
    return User.fromJson((jsonDecode(response.body) as Map<String, dynamic>)['data']);
  }
}