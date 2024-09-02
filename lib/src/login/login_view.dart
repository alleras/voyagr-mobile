import 'package:flutter/material.dart';
import 'package:voyagr_mobile/src/login/register_view.dart';
import '../trips/trip_list_view.dart';

/// Displays detailed information about a SampleItem.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
        Center(child:           
          Container(
            constraints: const BoxConstraints(maxWidth: 350),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0), 
            child: 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Voyagr'),
                  const SizedBox(height: 50),
                  const TextField(            
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                    ),
                  ),
                  const TextField(            
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () { 
                      Navigator.pushReplacementNamed(context, TripListView.routeName);
                    }, 
                    child: const Text('Login')
                  ),
                  const SizedBox(height: 20,),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegisterView.routeName);
                    },
                    child: const Text('Register')
                  )
              ],
            )
          ,)
        ,)
    );
  }
}
