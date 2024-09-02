import 'dart:convert';

import 'package:voyagr_mobile/models/user_model.dart';
import 'package:voyagr_mobile/services/base_api_service.dart';

class UsersService extends BaseApiService {
  Future<User> createUser(String name, String email) async {
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

    return User.fromJson((jsonDecode(response.body) as Map<String, dynamic>)['data']);
  }
}