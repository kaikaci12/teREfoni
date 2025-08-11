import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';

import 'package:frontend/utils/http/auth/register_user.dart';
import 'package:frontend/utils/providers/auth_provider.dart';
import 'package:frontend/utils/validator/validation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum SignUpMethod { email, phone }

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  // final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isPasswordVisible = false;
  bool isLoading = false;
  SignUpMethod _selectedMethod = SignUpMethod.email;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    // _idNumberController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  String? validateGeorgianPhone(String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return t.phoneRequired;
    final phoneRegex = RegExp(r'^5\d{8}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return t.georgianPhoneValidation;
    }
    return null;
  }

  String? validateID(String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return t.idRequired;
    if (value.length != 11) return t.idInvalid;
    return null;
  }

  void handleRegister() async {
    try {
      // Check if form validation passed
      if (!_formKey.currentState!.validate()) {
        debugPrint(_nameController.text);
        return; // Exit if validation fails
      }

      // Extract email, phone number, password, and name from the data map
      String email = _emailController.text;

      String phoneNumber = _phoneNumberController.text;
      String password = _passwordController.text;
      String firstName = _nameController.text;
      String lastName = _surnameController.text;

      await registerUser(
        email,
        phoneNumber,
        password,
        firstName,
        lastName,
        context,
      );

      // Show success snackbar
      showSuccessfulRegistration();

      GoRouter.of(context).go("/");
    } catch (e) {
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

  void showSuccessfulRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.registrationSuccess,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
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
                title: t.signUpWithEmail,
                icon: Icons.email_outlined,
                isSelected: _selectedMethod == SignUpMethod.email,
                onTap: () =>
                    setState(() => _selectedMethod = SignUpMethod.email),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMethodCard(
                title: t.signUpWithPhone,
                icon: Icons.phone_outlined,
                isSelected: _selectedMethod == SignUpMethod.phone,
                onTap: () =>
                    setState(() => _selectedMethod = SignUpMethod.phone),
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMethodSelector(),
          buildLabel(t.name),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(hintText: t.nameHint),
            validator: (value) => TValidator.validateName(context, value),
          ),
          const SizedBox(height: 16),
          buildLabel(t.surname),
          TextFormField(
            controller: _surnameController,
            decoration: InputDecoration(hintText: t.surnameHint),
            validator: (value) => TValidator.validatSurname(context, value),
          ),
          const SizedBox(height: 16),
          // buildLabel(t.idNumber),
          // TextFormField(
          //   controller: _idNumberController,
          //   keyboardType: TextInputType.number,
          //   decoration: InputDecoration(hintText: t.idNumberHint),
          //   validator: validateID,
          // ),
          // const SizedBox(height: 16),

          // Conditional fields based on selected method
          if (_selectedMethod == SignUpMethod.phone) ...[
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

          const SizedBox(height: 24),
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: handleRegister,
              child: Text(t.next),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }
}
