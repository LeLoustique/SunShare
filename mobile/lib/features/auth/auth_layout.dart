import 'package:flutter/material.dart';
import 'package:sunshare_api/sunshare_api.dart';

/// Libellés affichés pour les rôles (l'API renvoie `producer`, `consumer`…).
final roleLabels = <UserRole, String>{
  UserRole.producer: 'Producteur',
  UserRole.consumer: 'Consommateur',
  UserRole.mixed: 'Producteur et consommateur',
  UserRole.admin: 'Administrateur',
};

/// Mise en page commune aux écrans de connexion et d'inscription : formulaire centré, largeur
/// limitée (lisible sur le web), défilant quand le clavier est ouvert.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.title, required this.subtitle, required this.child});

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.wb_sunny_rounded, size: 56, color: theme.colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(title, textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(subtitle, textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 32),
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Message d'erreur sous un formulaire.
class FormError extends StatelessWidget {
  const FormError(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(message, style: TextStyle(color: colors.onErrorContainer)),
    );
  }
}

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return "Saisissez votre e-mail";
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) return 'E-mail invalide';
  return null;
}
