import 'package:flutter/material.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Name',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(hintText: 'John'),
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Surname',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _surnameController,
          keyboardType: TextInputType.name,
          decoration: const InputDecoration(hintText: 'Doe'),
        ),
        const SizedBox(height: 16.0),
        const Text(
          'ID Number',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _idNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: '1234567890123'),
        ),
        const SizedBox(height: 16.0),
        const Text(
          'Phone Number',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(hintText: '+1234567890'),
        ),
        const SizedBox(height: 24.0),
        const Text(
          'Email address',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'JahnDoe@example.com'),
        ),
        const SizedBox(height: 24.0),
        const Text(
          'Password',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
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
        ),
        const SizedBox(height: 16.0),
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
                // Handle forgot password
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
        const SizedBox(height: 32.0),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Handle signup logic
              print('Sign Up Button Pressed');
              print('Name: ${_nameController.text}');
              print('Surname: ${_surnameController.text}');
              print('ID Number: ${_idNumberController.text}');
              print('Phone Number: ${_phoneNumberController.text}');
              print('Email: ${_emailController.text}');
              print('Password: ${_passwordController.text}');
              print('Remember Me: $_rememberMe');
            },
            child: const Text('Next'),
          ),
        ),
      ],
    );
  }
}
