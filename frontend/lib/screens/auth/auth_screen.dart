import 'package:flutter/material.dart';

import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/main.dart';
import 'package:frontend/widgets/auth/sign_in_form.dart';
import 'package:frontend/widgets/auth/sign_up_form.dart';
import 'package:frontend/widgets/auth/social_login.dart';
import 'package:frontend/widgets/language_selector.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isSignUp = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 500 : size.width * 0.95,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 32.0 : 16.0,
                vertical: 16.0,
              ),
              child: Column(
                children: [
                  // Language Selector (Top-right)
                  Align(
                    alignment: Alignment.topRight,
                    child: LanguageSelector(),
                  ),

                  const SizedBox(height: 16.0),

                  // Main Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: _buildMainContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: Image.asset("assets/images/logo.png"),
                widthFactor: 100,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ტე",
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Text(
                  'RE',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
                const Text(
                  'ფონი',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32.0),

        // Toggle Tab
        Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isSignUp = false),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: _isSignUp ? Colors.transparent : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: _isSignUp ? Colors.grey[600] : Colors.teal,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _isSignUp = true),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: _isSignUp ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.signup,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: _isSignUp ? Colors.teal : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32.0),

        // Form
        _isSignUp ? const SignUpForm() : const SignInForm(),
        const SizedBox(height: 32.0),

        // Divider
        Row(
          children: [
            const Expanded(child: Divider(color: Colors.grey)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.continueWith,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            const Expanded(child: Divider(color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 24.0),

        // Social Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SocialLoginButton(
              icon: Image.asset(
                'assets/images/fb.png',
                width: 32,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.facebook,
                  size: 32,
                  color: Color(0xFF3b5998),
                ),
              ),

              onPressed: () {},
            ),
            const SizedBox(width: 24.0),
            SocialLoginButton(
              icon: Image.asset(
                'assets/images/google.png',
                width: 32,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.g_mobiledata,

                  size: 32,
                  color: Color(0xFFDB4437),
                ),
              ),

              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
