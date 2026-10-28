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

final _eurPerKwhInput = RegExp(r'^(\d)(?:[.,](\d{1,4}))?$');

/// Tarif saisi (« 0,18 », « 0.165 ») → chaîne décimale exacte pour l'API (« 0.18 »), ou null si le
/// format est invalide (moins de 10 €, 4 décimales au plus, comme le serveur).
String? parseEurPerKwh(String input) {
  final match = _eurPerKwhInput.firstMatch(input.trim());
  if (match == null) return null;
  final decimals = match.group(2);
  return decimals == null ? match.group(1)! : '${match.group(1)}.$decimals';
}

/// Tarif en dix-millièmes d'euro (entier exact) pour comparer deux tarifs sans flottant.
int eurPerKwhUnits(String eurPerKwh) {
  final parts = eurPerKwh.split('.');
  final decimals = (parts.length > 1 ? parts[1] : '').padRight(4, '0');
  return int.parse(parts[0]) * 10000 + int.parse(decimals);
}

/// Saisie d'un tarif existant dans un formulaire : « 0.1800 » → « 0,18 ».
String priceInput(String eurPerKwh) => formatPrice(eurPerKwh).replaceAll(' €/kWh', '');

/// Montant reçu en chaîne exacte (« 25.65 ») → « 25,65 € », sans passer par un flottant.
String formatEuros(String amount) => '${amount.replaceAll('.', ',')} €';

/// Énergie d'un total (mois, journée) : « 142,5 kWh », au dixième.
String formatKwh(num kwh) => '${_number((kwh * 10).round() / 10)} kWh';

/// Taux entre 0 et 1 → « 63 % » (espace insécable avant %).
String formatPercent(num rate) => '${(rate * 100).round()} %';

const _months = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

/// « octobre 2026 »
String formatMonth(int year, int month) => '${_months[month - 1]} $year';

/// « 2026-10 », format du paramètre `period` de l'API.
String periodOf(int year, int month) => '$year-${_two(month)}';
