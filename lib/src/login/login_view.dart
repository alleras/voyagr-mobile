import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/providers/users_provider.dart';
import 'package:voyagr_mobile/src/login/register_view.dart';
import '../trips/trip_list_view.dart';

/// Displays detailed information about a SampleItem.
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  static const routeName = '/';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _loginFailed = false;

  void performLogin(BuildContext context) async {
    setState(() => _loginFailed = false);
    if (!_formKey.currentState!.validate()) return;
    if(!context.mounted) return;

    bool loginResult = await Provider.of<UsersProvider>(context, listen: false)
      .loginUser(emailController.text, passwordController.text);
    setState(() => _loginFailed = !loginResult);

    if(!_loginFailed && context.mounted) Navigator.pushReplacementNamed(context, TripListView.routeName);
  }

  Widget buildLoginError() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.redAccent, width: 0.5),
          borderRadius: const BorderRadius.all(Radius.circular(5))
        ),
        child: const Text('Username or Password not found'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Center(child:           
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: Wrap(
                runSpacing: 10.0,
                children: [
                    const Center(child: Text('Voyagr')),
                    const SizedBox(height: 50),
            
                    if (_loginFailed) ...[
                      buildLoginError(),
                    ],
                    TextFormField(        
                      controller: emailController,    
                      decoration: const InputDecoration(
                        hintText: 'E-mail',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your E-mail';
                        return null;
                      },
                    ),
                    TextFormField(           
                      controller: passwordController, 
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter your password';
                        return null;
                      },
                    ),
            
                    const SizedBox(height: 80,),
                    Center(
                      child: FilledButton(
                        onPressed: () { 
                          performLogin(context);
                        }, 
                        child: const Text('Login')
                      ),
                    ),
                    const SizedBox(height: 50,),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterView.routeName);
                        },
                        child: const Text('Register')
                      ),
                    )
                ],  
              ),
            ),
          )
        ,)
    );
  }
}
