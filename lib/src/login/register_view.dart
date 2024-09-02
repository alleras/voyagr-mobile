import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/models/user_model.dart';
import 'package:voyagr_mobile/providers/users_provider.dart';
import 'package:voyagr_mobile/src/login/password_presenter_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  static const routeName = '/register';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  bool _creatingUser = false;
  User? user;

  void createUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    _creatingUser = true;
    var user = await Provider.of<UsersProvider>(context, listen: false).createUser(nameController.text, emailController.text);

    if (context.mounted && user != null) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(
          builder: (context) => PasswordPresenterView(user: user)
        )
      );
    }
  }

  Widget buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0,
        children: [
          const Text("Let's create your account"),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "What's your name?",
            ),
            controller: nameController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter a name';
              return null;
            }
          ),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Tell us your e-mail",
            ),
            controller: emailController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your email address';
              return null;
            }
          ),
    
          const SizedBox(height: 100),
          Center(child: 
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(170, 50)),
              onPressed: () async {
                if(_creatingUser) return;
                createUser(context);
              },
              child: _creatingUser ? const CircularProgressIndicator() : const Text('Create Account'),
            )
          ,),
              
          Center(child: 
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(170, 50)),
              onPressed: _creatingUser ? null : () { Navigator.pop(context); },
              child: const Text('Cancel'),
            )
          ,)
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a New Account'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: buildRegistrationForm()
        ),
      ),
    );
  }
}