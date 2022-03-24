import 'dart:html';

class TokenSession
{
  static set setToken(String value) => window.sessionStorage["jwt"] = value;
  static String get getToken => window.sessionStorage["jwt"];
}