import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../../core/format.dart';
import '../auth/auth_layout.dart';
import 'admin_repository.dart';

/// Périmètres prévus par la réglementation : 2 km, ou 10 / 20 km sur dérogation.
const perimeterChoices = <int, String>{
  2: '2 km',
  10: '10 km (dérogation)',
  20: '20 km (dérogation, zone rurale)',
};

/// Création (loopId null) ou modification d'une boucle.
class LoopFormScreen extends ConsumerWidget {
  const LoopFormScreen({super.key, this.loopId});

  final String? loopId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = loopId;
    if (id == null) return const _LoopForm(loop: null);
    return switch (ref.watch(adminLoopProvider(id))) {
      AsyncData(value: final loop?) => _LoopForm(loop: loop),
      AsyncData() => const Scaffold(body: Center(child: Text('Boucle introuvable'))),
      AsyncError(:final error) => Scaffold(body: Center(child: Text(errorMessage(error)))),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}

class _LoopForm extends ConsumerStatefulWidget {
  const _LoopForm({required this.loop});

  final AdminLoopOut? loop;

  @override
  ConsumerState<_LoopForm> createState() => _LoopFormState();
}

class _LoopFormState extends ConsumerState<_LoopForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.loop?.name);
  late final _price = TextEditingController(
    text: widget.loop == null ? '' : priceInput(widget.loop!.priceEurKwh),
  );
  late final _commission = TextEditingController(
    text: widget.loop == null ? '' : priceInput(widget.loop!.commissionEurKwh),
  );
  late final _enedisId = TextEditingController(text: widget.loop?.enedisOperationId);
  late int _perimeter = widget.loop?.perimeterKm.round() ?? 2;
  late AllocationMode _allocation = widget.loop?.allocationMode ?? AllocationMode.dynamicDefault;
  late bool _open = widget.loop?.status != LoopStatus.closed;
  bool _submitting = false;
  String? _error;

  bool get _editing => widget.loop != null;

  @override
  void dispose() {
    for (final c in [_name, _price, _commission, _enedisId]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validatePrice(String? value) =>
      parseEurPerKwh(value ?? '') == null ? 'Montant en €/kWh, 4 décimales au plus (ex. 0,18)' : null;

  String? _validateCommission(String? value) {
    final commission = parseEurPerKwh(value ?? '');
    if (commission == null) return 'Montant en €/kWh, 4 décimales au plus (ex. 0,02)';
    final price = parseEurPerKwh(_price.text);
    if (price != null && eurPerKwhUnits(commission) >= eurPerKwhUnits(price)) {
      return 'La commission doit être inférieure au tarif';
    }
    return null;
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final repository = ref.read(adminRepositoryProvider);
    final enedisId = _enedisId.text.trim();
    try {
      final AdminLoopOut saved;
      if (_editing) {
        saved = await repository.update(
          widget.loop!.id,
          LoopUpdate((b) => b
            ..name = _name.text.trim()
            ..perimeterKm = _perimeter
            ..priceEurKwh = parseEurPerKwh(_price.text)
            ..commissionEurKwh = parseEurPerKwh(_commission.text)
            ..allocationMode = _allocation
            ..status = _open ? LoopStatus.open : LoopStatus.closed
            ..enedisOperationId = enedisId.isEmpty ? null : enedisId),
        );
      } else {
        saved = await repository.create(LoopCreate((b) => b
          ..name = _name.text.trim()
          ..perimeterKm = _perimeter
          ..priceEurKwh = parseEurPerKwh(_price.text)
          ..commissionEurKwh = parseEurPerKwh(_commission.text)
          ..allocationMode = _allocation
          ..enedisOperationId = enedisId.isEmpty ? null : enedisId));
      }
      ref.invalidate(adminLoopsProvider);
      if (mounted) context.go('/admin/boucles/${saved.id}');
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_editing ? 'Modifier la boucle' : 'Nouvelle boucle')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Nom de la boucle'),
                    maxLength: 100,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Donnez un nom à la boucle' : null,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    initialValue: _perimeter,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Périmètre',
                      helperText: 'Distance maximale entre les deux sites les plus éloignés',
                    ),
                    items: [
                      for (final entry in perimeterChoices.entries)
                        DropdownMenuItem(value: entry.key, child: Text(entry.value)),
                      // Valeur posée hors application (API) : on la garde sélectionnable
                      if (!perimeterChoices.containsKey(_perimeter))
                        DropdownMenuItem(value: _perimeter, child: Text('$_perimeter km')),
                    ],
                    onChanged: (v) => setState(() => _perimeter = v!),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _price,
                          decoration: const InputDecoration(
                            labelText: 'Tarif',
                            suffixText: '€/kWh',
                            helperText: 'Payé par le consommateur',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _validatePrice,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _commission,
                          decoration: const InputDecoration(
                            labelText: 'Commission',
                            suffixText: '€/kWh',
                            helperText: 'Retenue par l’app',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: _validateCommission,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<AllocationMode>(
                    initialValue: _allocation,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Clé de répartition'),
                    items: [
                      for (final entry in allocationModeLabels.entries)
                        DropdownMenuItem(value: entry.key, child: Text(entry.value)),
                    ],
                    onChanged: (v) => setState(() => _allocation = v!),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _enedisId,
                    decoration: const InputDecoration(
                      labelText: 'Identifiant de l’opération chez Enedis (facultatif)',
                    ),
                    maxLength: 50,
                  ),
                  if (_editing)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Ouverte aux nouvelles demandes'),
                      value: _open,
                      onChanged: (v) => setState(() => _open = v),
                    ),
                  const SizedBox(height: 16),
                  if (_error != null) ...[FormError(_error!), const SizedBox(height: 16)],
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox.square(
                            dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(_editing ? 'Enregistrer' : 'Créer la boucle'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
