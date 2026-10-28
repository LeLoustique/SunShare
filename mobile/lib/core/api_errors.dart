import 'package:dio/dio.dart';

/// Message lisible pour l'utilisateur à partir d'une erreur d'appel à l'API.
String errorMessage(Object error) {
  if (error is DioException) {
    final response = error.response;
    if (response == null) return 'Impossible de joindre le serveur. Vérifiez votre connexion.';

    // Les erreurs métier de l'API sont en français dans `detail` (ex. « E-mail déjà utilisé »)
    final data = response.data;
    final detail = data is Map ? data['detail'] : null;
    if (detail is String) return detail;
    if (response.statusCode == 422) return 'Certaines informations sont invalides.';
  }
  return 'Une erreur inattendue est survenue. Réessayez.';
}
