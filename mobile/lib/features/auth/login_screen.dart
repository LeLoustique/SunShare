import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/api_errors.dart';
import 'auth_controller.dart';
import 'auth_layout.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      // En cas de succès, le routeur bascule seul vers le profil
      await ref.read(authControllerProvider.notifier).login(_email.text, _password.text);
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Connexion',
      subtitle: "Partagez l'énergie solaire de votre quartier",
      child: Form(
        key: _formKey,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
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
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Afficher' : 'Masquer',
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                obscureText: _obscure,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _submit(),
                validator: (v) => (v == null || v.isEmpty) ? 'Saisissez votre mot de passe' : null,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[FormError(_error!), const SizedBox(height: 16)],
              FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Se connecter'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/inscription'),
                child: const Text('Pas encore de compte ? Créer un compte'),
              ),
              TextButton.icon(
                onPressed: () => context.push('/etat-api'),
                icon: const Icon(Icons.dns_outlined, size: 18),
                label: const Text('État du serveur'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
