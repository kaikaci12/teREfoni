import 'package:frontend/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import "package:flutter/material.dart";
import '../constants/text_strings.dart';
import 'package:flutter/material.dart';

/// VALIDATION CLASS
class TValidator {
  /// Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }

    return null;
  }

  static String? validatePinCode(String? pinCode) {
    if (pinCode == null || pinCode.isEmpty) {
      return 'Pin Code is required.';
    }

    // Check for minimum pinCode length
    if (pinCode.length < 6) {
      return 'Pin Code must be 6 Digits.';
    }

    return null;
  }

  static String? validateAge(String? input) {
    if (input == null || input.isEmpty) {
      return 'Date of Birth is required.';
    }

    try {
      // Parse the input date in the 'dd-MMM-yyyy' format
      final DateFormat format = DateFormat('dd-MMM-yyyy');
      final DateTime dateOfBirth = format.parse(input);

      final DateTime today = DateTime.now();
      final int age =
          today.year -
          dateOfBirth.year -
          ((today.month < dateOfBirth.month ||
                  (today.month == dateOfBirth.month &&
                      today.day < dateOfBirth.day))
              ? 1
              : 0);

      if (age < 18) {
        return TTexts.dateOfBirthError;
      }
    } catch (e) {
      return 'Invalid date format. Use dd-MMM-yyyy.';
    }

    return null;
  }

  /// Username Validation
  static String? validateName(BuildContext context, String? username) {
    final t = AppLocalizations.of(context)!;
    if (username == null || username.isEmpty) {
      return t.nameRequired;
    }

    bool isValid =
        !username.startsWith('_') &&
        !username.startsWith('-') &&
        !username.endsWith('_') &&
        !username.endsWith('-') &&
        username.length > 2;

    if (!isValid) {
      return t.nameTooShort;
    }

    return null;
  }

  static String? validatSurname(BuildContext context, String? username) {
    final t = AppLocalizations.of(context)!;
    if (username == null || username.isEmpty) {
      return t.surnameRequired;
    }

    // Check if the username doesn't start or end with an underscore or hyphen.

    bool isValid =
        !username.startsWith('_') &&
        !username.startsWith('-') &&
        !username.endsWith('_') &&
        !username.endsWith('-') &&
        username.length > 2;

    if (!isValid) {
      return t.surnameTooShort;
    }

    return null;
  }

  /// Email Validation
  static String? validateEmail(BuildContext context, String? value) {
    final t = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return t.emailRequired;
    }

    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return t.invalidEmail;
    }

    return null;
  }

  static String? validatePassword(BuildContext context, String? value) {
    final t = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return t.passwordRequired;
    }

    if (value.length < 6) {
      return t.passwordTooShort;
    }

    return null;
  }

  /// Phone Number Validation
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    final returnValue = validatePhoneNumberFormat(value);

    return returnValue;
  }

  static String? validatePhoneNumberFormat(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

  // Add more custom validators as needed for your specific requirements.
}
