import 'package:flutter/material.dart';
import 'package:frontend/main.dart';

class LanguageSelector extends StatefulWidget {
  static const languageOptions = [
    {'code': "ka", 'label': "GE", 'flagUrl': 'https://flagcdn.com/w40/ge.png'},
    {'code': 'en', 'label': 'EN', 'flagUrl': 'https://flagcdn.com/w40/us.png'},
  ];
  const LanguageSelector({Key? key}) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  static var selectedLang = "ka";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedLang,
        icon: const Icon(Icons.keyboard_arrow_down),
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedLang = value;
              Locale newLocale = Locale(value);
              MyApp.setLocale(context, newLocale);
            });
          }
        },
        items: LanguageSelector.languageOptions.map((lang) {
          return DropdownMenuItem<String>(
            value: lang['code'],
            child: Row(
              children: [
                Image.network(
                  lang['flagUrl']!,
                  width: 24,
                  height: 16,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.flag, size: 24),
                ),
                const SizedBox(width: 8.0),
                Text(lang['label']!),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
