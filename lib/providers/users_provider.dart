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

  Future<void> deleteCurrentUser() async {
    try {
      await UsersService().deleteUser(_currentUser!.email);
    }
    catch(e) {
      showError(e.toString());
    }
  }

  void performLogout() {
    _currentUser = null;
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    try {
      if (oldPassword != _currentUser!.password){
        return false;
      }

      await UsersService().changePassword(_currentUser!, oldPassword, newPassword);
      _currentUser!.password = newPassword;
      return true;
    }
    catch(e) {
      showError(e.toString());
      return false;
    }
  }

  Future<UserRegistrationResponse?> createUser(String name, String email) async {
    try{
      return  await UsersService().createUser(name, email);
    }
    catch(e){
      showError(e.toString());
      return null;
    }
  }

  Future<bool> loginUser(String email, String password) async {
    try{
      var user = await UsersService().getUser(email);

      if (user == null || user.password != password) {
        return false;
      }

      _currentUser = user;
      return true;
    }
    catch(e){
      showError(e.toString());
      return false;
    }
  }
}