import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voyagr_mobile/providers/users_provider.dart';

class PasswordChangeView extends StatefulWidget {
  const PasswordChangeView({super.key});

  static const routeName = '/register';

  @override
  State<PasswordChangeView> createState() => _PasswordChangeViewState();
}

class _PasswordChangeViewState extends State<PasswordChangeView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  bool _changingPassword = false;
  bool _error = false;

  void changePassword(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _changingPassword = true);
    bool changeResult = await Provider.of<UsersProvider>(context, listen: false)
      .changePassword(oldPasswordController.text, newPasswordController.text);

    setState(() => _error = !changeResult);

    if(context.mounted && changeResult) Navigator.pop(context);
    setState(() => _changingPassword = false);
  }

  Widget buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 12.0,
        children: [
          if(_error) ...[
            Center(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent, width: 0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: const Text("The password you provided is incorrect."),
              ),
            )
          ],
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Old Password",
            ),
            controller: oldPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your old password';
              return null;
            }
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "New Password",
            ),
            controller: newPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please enter your new password';
              return null;
            }
          ),
    
          const SizedBox(height: 100),
          Center(child: 
            FilledButton(
              style: FilledButton.styleFrom(minimumSize: const Size(170, 50)),
              onPressed: () async {
                if(_changingPassword) return;
                changePassword(context);
              },
              child: _changingPassword ? const CircularProgressIndicator() : const Text('Change Password'),
            )
          ,),
              
          Center(child: 
            TextButton(
              style: TextButton.styleFrom(minimumSize: const Size(170, 50)),
              onPressed: _changingPassword ? null : () { Navigator.pop(context); },
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
        title: const Text('Change your password'),
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