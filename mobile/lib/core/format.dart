import 'package:sunshare_api/sunshare_api.dart';

/// Formats d'affichage en français (virgule décimale, jj/mm/aaaa).

String _two(int n) => n.toString().padLeft(2, '0');

/// « 28/10/2026 », en heure locale.
String formatDateTime(DateTime date) {
  final d = date.toLocal();
  return '${_two(d.day)}/${_two(d.month)}/${d.year}';
}

/// Date sans heure renvoyée par l'API (date d'entrée dans une boucle…).
String formatDay(Date date) => '${_two(date.day)}/${_two(date.month)}/${date.year}';

/// Nombre sans zéros inutiles, virgule décimale : 6 → « 6 », 6.5 → « 6,5 ».
String _number(num value) {
  final text = value == value.roundToDouble() ? value.toInt().toString() : value.toString();
  return text.replaceAll('.', ',');
}

/// « 6,5 kWc »
String formatKw(num kw) => '${_number(kw)} kWc';

/// « 2 km », « 0,81 km » (arrondi à 10 m)
String formatKm(num km) => '${_number((km * 100).round() / 100)} km';

/// Tarif reçu en chaîne décimale exacte (« 0.1800 ») → « 0,18 €/kWh ».
/// Travaille sur le texte, sans passer par un flottant : au moins 2 décimales, 4 au plus.
String formatPrice(String eurPerKwh) {
  final parts = eurPerKwh.split('.');
  var decimals = parts.length > 1 ? parts[1].replaceFirst(RegExp(r'0+$'), '') : '';
  decimals = decimals.padRight(2, '0');
  return '${parts[0]},$decimals €/kWh';
}
