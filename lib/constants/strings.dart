import 'dart:math';

class Strings {
  Strings._();

  //General
  static const String appName = "FreeTuber";

  static const String keywordBoxName = "HistoryKeyword";

  static const List<String> listApikey = [
    "AIzaSyCf_FlUF4O2PPFRarkP1Z9smIK3b_ZY4Fk",
    "AIzaSyAMbu7bI4vxOiKOR4s6uRE8hS38itCRa9Q",
    "AIzaSyC6EsWynC4Rci8sqT5uqIe4fpjSZdbarvQ",
    "AIzaSyCXhMaMS1YIvfBvHlRuvF6HSLzbTu3M4SM",
    "AIzaSyAH1IOodPdUkqWriVI1FftVUk7VYc5ikW8",
  ];

  static String apikey = listApikey.elementAt(Random().nextInt(listApikey.length));

  static const String categoryCodeMusic = '10';
  static const String categoryCodeGame = '20';
  static const String categoryCodeEntertainment = '24';
  static const String categoryCodeSport = '17';
  static const String none = 'none';
}
