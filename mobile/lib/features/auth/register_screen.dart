import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import 'auth_controller.dart';
import 'auth_layout.dart';

/// Même règle que le backend (UserCreate.password).
const minPasswordLength = 10;

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  UserRole _role = UserRole.consumer;
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_firstName, _lastName, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      // En cas de succès, l'utilisateur est connecté et le routeur bascule vers le profil
      await ref.read(authControllerProvider.notifier).register(
            email: _email.text,
            password: _password.text,
            firstName: _firstName.text,
            lastName: _lastName.text,
            role: _role,
          );
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String? _required(String? value, String message) =>
      (value == null || value.trim().isEmpty) ? message : null;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Créer un compte',
      subtitle: 'Rejoignez une boucle d’autoconsommation collective',
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Je suis…', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              SegmentedButton<UserRole>(
                segments: const [
                  ButtonSegment(
                    value: UserRole.producer,
                    icon: Icon(Icons.solar_power_outlined),
                    label: Text('Producteur'),
                  ),
                  ButtonSegment(
                    value: UserRole.consumer,
                    icon: Icon(Icons.home_outlined),
                    label: Text('Consommateur'),
                  ),
                  ButtonSegment(
                    value: UserRole.mixed,
                    icon: Icon(Icons.sync_alt),
                    label: Text('Les deux'),
                  ),
                ],
                selected: {_role},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _role = s.first),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _firstName,
                decoration: const InputDecoration(labelText: 'Prénom'),
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.givenName],
                textInputAction: TextInputAction.next,
                validator: (v) => _required(v, 'Saisissez votre prénom'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastName,
                decoration: const InputDecoration(labelText: 'Nom'),
                textCapitalization: TextCapitalization.words,
                autofillHints: const [AutofillHints.familyName],
                textInputAction: TextInputAction.next,
                validator: (v) => _required(v, 'Saisissez votre nom'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                autofillHints: const [AutofillHints.email],
                textInputAction: TextInputAction.next,
                validator: validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  helperText: '$minPasswordLength caractères minimum',
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Afficher' : 'Masquer',
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                obscureText: _obscure,
                autofillHints: const [AutofillHints.newPassword],
                textInputAction: TextInputAction.next,
                validator: (v) => (v == null || v.length < minPasswordLength)
                    ? 'Au moins $minPasswordLength caractères'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirm,
                decoration: const InputDecoration(labelText: 'Confirmer le mot de passe'),
                obscureText: _obscure,
                onFieldSubmitted: (_) => _submit(),
                validator: (v) =>
                    v != _password.text ? 'Les mots de passe ne correspondent pas' : null,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[FormError(_error!), const SizedBox(height: 16)],
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Créer mon compte'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/connexion'),
                child: const Text('Déjà un compte ? Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
