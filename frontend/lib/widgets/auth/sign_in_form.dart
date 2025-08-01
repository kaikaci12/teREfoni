import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/utils/http/auth/login_user.dart';
import 'package:frontend/utils/providers/auth_provider.dart';
import 'package:frontend/utils/validator/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  void handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!context.mounted) return;
    final data = {
      "email": _emailController.text,
      "password": _passwordController.text,
    };

    try {
      await loginUser(context, "api/auth/login", data);

      Provider.of<AuthProvider>(context, listen: false).setAuthenticated(true);
      GoRouter.of(context).go("/");
    } catch (e) {
      print(e.toString());
      showErrorMessage(e);
    }
  }

  void showErrorMessage(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.email,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: t.emailHint),
            validator: (value) => TValidator.validateEmail(context, value),
          ),
          const SizedBox(height: 24.0),
          Text(
            t.password,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: t.passwordHint,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) => TValidator.validatePassword(context, value),
          ),
          const SizedBox(height: 16.0),
          TextButton(
            onPressed: () {
              // TODO: Implement forgot password
            },
            child: Text(
              t.forgotPassword,
              style: const TextStyle(
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: handleLogin, child: Text(t.next)),
          ),
        ],
      ),
    );
  }
}
