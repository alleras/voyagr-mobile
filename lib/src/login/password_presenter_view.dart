import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/models/user_model.dart';
import 'package:voyagr_mobile/providers/users_provider.dart';
import 'package:voyagr_mobile/src/trips/trip_list_view.dart';

class PasswordPresenterView extends StatefulWidget {
  final User user;
  const PasswordPresenterView({super.key, required this.user});

  @override
  State<PasswordPresenterView> createState() => _PasswordPresenterViewState();
}

class _PasswordPresenterViewState extends State<PasswordPresenterView> {
  bool _obscureText = true;
  final TextEditingController passwordPresenterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    passwordPresenterController.text = widget.user.password;
  }

  void assignUserAndGoToMainPage(){
    Provider.of<UsersProvider>(context, listen: false).setCurrentUserSession(widget.user);
    Navigator.pushNamedAndRemoveUntil(context, TripListView.routeName, (_) => false);
  }

  Widget buildPasswordPresenter() {
    return Wrap(
      runSpacing: 12.0,
      children: [
        const Center(
          child: Text(
            'Your user has been created',
            style: TextStyle(fontSize: 22),
          )
        ),
        const SizedBox(height: 50,),

        const Center(child: Text('Please take note of your password before continuing:')),
        TextField(
          readOnly: true,
          obscureText: _obscureText,
          controller: passwordPresenterController,
          decoration: InputDecoration(  
            labelText: 'Password',
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText; // Toggle the visibility
                });
              },
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        
        const SizedBox(height: 70,),
        Center(child: 
          FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(170, 50)),
            onPressed: () {
              assignUserAndGoToMainPage();
            },
            child: const Text('Continue to Account'),
          )
        ,),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: buildPasswordPresenter()),
      )
    );
  }
}