import 'package:flutter/material.dart';

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

  bool _rememberMe = false;
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

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateGeorgianPhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^\+9955\d{8}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Enter a valid Georgian number (e.g. +9955XXXXXXXX)';
    }
    return null;
  }

  String? validateID(String? value) {
    if (value == null || value.isEmpty) return 'ID Number is required';
    if (value.length != 11) return 'ID Number must be exactly 11 digits';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildLabel('Name'),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'John'),
            validator: (value) => value!.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          buildLabel('Surname'),
          TextFormField(
            controller: _surnameController,
            decoration: const InputDecoration(hintText: 'Doe'),
            validator: (value) => value!.isEmpty ? 'Surname is required' : null,
          ),
          const SizedBox(height: 16),
          buildLabel('ID Number'),
          TextFormField(
            controller: _idNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '12345678901'),
            validator: validateID,
          ),
          const SizedBox(height: 16),
          buildLabel('Phone Number'),

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
                  decoration: const InputDecoration(hintText: '5XXXXXXXX'),
                  validator: validateGeorgianPhone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          buildLabel('Email address'),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'johndoe@example.com'),
            validator: validateEmail,
          ),
          const SizedBox(height: 24),
          buildLabel('Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Your password',
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
            validator: validatePassword,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _rememberMe = newValue!;
                      });
                    },
                    activeColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const Text('Remember me'),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Forgot password logic
                },
                child: const Text(
                  'Forgot your password?',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
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
                  print('Remember Me: $_rememberMe');
                }
              },
              child: const Text('Next'),
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
