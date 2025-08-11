import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/utils/http/auth/login_user.dart';

import 'package:frontend/utils/validator/validation.dart';
import 'package:go_router/go_router.dart';

enum SignInMethod { email, phone }

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isPasswordVisible = false;
  SignInMethod _selectedMethod = SignInMethod.email;

  String? validateGeorgianPhone(String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return t.phoneRequired;
    final phoneRegex = RegExp(r'^5\d{8}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return t.georgianPhoneValidation;
    }
    return null;
  }

  void handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!context.mounted) return;

    String email = _emailController.text;
    String password = _passwordController.text;
    String phoneNumber = _phoneNumberController.text;
    // Add email or phone based on selected method

    try {
      await loginUser(email, phoneNumber, password, context);

      GoRouter.of(context).go("/");
    } catch (e) {
      debugPrint("Login Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll('Exception: ', ''),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Widget _buildMethodSelector() {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMethodCard(
                title: t.signInWithEmail,
                icon: Icons.email_outlined,
                isSelected: _selectedMethod == SignInMethod.email,
                onTap: () =>
                    setState(() => _selectedMethod = SignInMethod.email),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMethodCard(
                title: t.signInWithPhone,
                icon: Icons.phone_outlined,
                isSelected: _selectedMethod == SignInMethod.phone,
                onTap: () =>
                    setState(() => _selectedMethod = SignInMethod.phone),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMethodCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMethodSelector(),

          // Conditional fields based on selected method
          if (_selectedMethod == SignInMethod.phone) ...[
            buildLabel(t.phoneNumber),
            Row(
              children: [
                Row(
                  children: [
                    Image.network(
                      "https://flagcdn.com/w40/ge.png",
                      width: 15,
                      height: 10,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.flag, size: 15),
                    ),
                    const SizedBox(width: 4),
                    const Text("+995"),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    maxLength: 9,
                    decoration: InputDecoration(hintText: t.phoneNumberHint),
                    validator: validateGeorgianPhone,
                  ),
                ),
              ],
            ),
          ] else ...[
            buildLabel(t.email),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: t.emailHint),
              validator: (value) => TValidator.validateEmail(context, value),
            ),
          ],

          const SizedBox(height: 24.0),
          buildLabel(t.password),
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
