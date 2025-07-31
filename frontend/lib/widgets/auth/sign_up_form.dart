import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/utils/validator/validation.dart';

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
  final TextEditingController _idNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _idNumberController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  String? validateGeorgianPhone(String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return t.phoneRequired;
    final phoneRegex = RegExp(r'^\+9955\d{8}$');
    if (!phoneRegex.hasMatch(value)) {
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

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          buildLabel(t.idNumber),
          TextFormField(
            controller: _idNumberController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: t.idNumberHint),
            validator: validateID,
          ),
          const SizedBox(height: 16),
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
                  decoration: InputDecoration(hintText: t.phoneNumberHint),
                  validator: validateGeorgianPhone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          buildLabel(t.email),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: t.emailHint),
            validator: (value) => TValidator.validateEmail(context, value),
          ),
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
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print('✅ All valid');
                  print('Name: ${_nameController.text}');
                  print('Surname: ${_surnameController.text}');
                  print('ID: ${_idNumberController.text}');
                  print('Phone: ${_phoneNumberController.text}');
                  print('Email: ${_emailController.text}');
                  print('Password: ${_passwordController.text}');
                }
              },
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
