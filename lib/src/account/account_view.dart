import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/models/user_model.dart';
import 'package:voyagr_mobile/providers/users_provider.dart';
import 'package:voyagr_mobile/src/account/password_change_view.dart';
import 'package:voyagr_mobile/src/login/login_view.dart';
import 'package:voyagr_mobile/util/constants.dart';

class AccountView extends StatelessWidget {
  final User user;
  const AccountView({super.key, required this.user});

  Widget buildUserAvatar(){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(Constants.PROFILE_PLACEHOLDER_URL),
        ),
        const SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              user.email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          buildUserAvatar(),
          const SizedBox(height: 20,),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Password Change'),
            subtitle: const Text('Change your password to something else.'),
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(
                  builder: (context) => const PasswordChangeView()
                )
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            subtitle: const Text('Log out from your account.'),
            onTap: (){
              showDialog<String>(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Log out'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Provider.of<UsersProvider>(context, listen: false).performLogout();
                        Navigator.pushNamedAndRemoveUntil(context, LoginView.routeName, (_) => false);
                      },
                      child: const Text('Log out'),
                    ),
                  ],
                )
              );
            }
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete User'),
            subtitle: const Text('Delete your user permanently.'),
            onTap: (){
              showDialog<String>(
                context: context, 
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Delete User'),
                  content: const Text('Are you sure you want to delete your user? This action cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () {
                        Provider.of<UsersProvider>(context, listen: false).deleteCurrentUser();
                        Navigator.pushNamedAndRemoveUntil(context, LoginView.routeName, (_) => false);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                )
              );
            }
          ),
        ],
      )
    );
  }
}