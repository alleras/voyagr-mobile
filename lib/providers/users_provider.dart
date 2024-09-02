import 'package:voyagr_mobile/models/user_model.dart';
import 'package:voyagr_mobile/providers/base_provider.dart';
import 'package:voyagr_mobile/services/users_service.dart';

class UsersProvider extends BaseProvider {
  UsersProvider({required super.context});

  User? _currentUser;
  User? get currentUser => _currentUser;

  void setCurrentUserSession(User user) {
    _currentUser = user;
  }

  Future<User?> createUser(String name, String email) async {
    try{
      var user = await UsersService().createUser(name, email);
      return user;
    }
    catch(e){
      showError(e.toString());
      return null;
    }
  }
}