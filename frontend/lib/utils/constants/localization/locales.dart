import 'package:flutter_localization/flutter_localization.dart';

const List<MapLocale> LOCALES = [
  MapLocale("ka", LocaleData.KA),
  MapLocale("en", LocaleData.EN),
];

mixin LocaleData {
  static const String title = "title";
  static const String body = "body";
  static const String login = "login";
  static const String signup = "signup";
  static const String orContinueWith = "orContinueWith";

  static const Map<String, dynamic> EN = {
    title: "TeREfoni",
    body: "Welcome to this localized Flutter Application",
    login: "Log in",
    signup: "Sign up",
    orContinueWith: "Or Continue with",
  };

  static const Map<String, dynamic> KA = {
    title: "ტეREფონი",
    body: "კეთილი იყოს თქვენი ფეხი ლოკალიზებულ ფლატერის აპლიკაციაში",
    login: "შესვლა",
    signup: "რეგისტრაცია",
    orContinueWith: "ან გააგრძელეთ",
  };
}
