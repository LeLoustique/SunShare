import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sunshare_api/sunshare_api.dart';

import '../../core/api_errors.dart';
import '../auth/auth_controller.dart';
import '../auth/auth_layout.dart';
import 'meters_repository.dart';

const prmLength = 14;

/// Attente après la dernière frappe avant d'interroger la Base Adresse Nationale.
const addressDebounce = Duration(milliseconds: 300);

class AddMeterScreen extends ConsumerStatefulWidget {
  const AddMeterScreen({super.key});

  @override
  ConsumerState<AddMeterScreen> createState() => _AddMeterScreenState();
}

class _AddMeterScreenState extends ConsumerState<AddMeterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _prm = TextEditingController();
  final _peakKw = TextEditingController();
  late MeterDirection _direction;
  AddressSuggestion? _address;
  String _addressText = '';
  int _lastSearch = 0;
  String? _addressServiceError;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final role = ref.read(authControllerProvider).value!.role;
    _direction = allowedDirections(role).first;
  }

  @override
  void dispose() {
    _prm.dispose();
    _peakKw.dispose();
    super.dispose();
  }

  Future<Iterable<AddressSuggestion>> _suggest(TextEditingValue value) async {
    final query = value.text.trim();
    if (query.length < 3 || query == _address?.label) return const [];

    final search = ++_lastSearch;
    await Future<void>.delayed(addressDebounce);
    if (search != _lastSearch) return const []; // une frappe plus récente a pris le relais

    try {
      final suggestions = await ref.read(metersRepositoryProvider).searchAddresses(query);
      if (mounted && _addressServiceError != null) setState(() => _addressServiceError = null);
      return suggestions;
    } catch (e) {
      if (mounted) setState(() => _addressServiceError = errorMessage(e));
      return const [];
    }
  }

  num? _parseKw(String text) => num.tryParse(text.trim().replaceAll(',', '.'));

  String? _validatePrm(String? value) {
    if (value == null || value.isEmpty) return 'Saisissez le numéro PRM';
    if (value.length != prmLength) return 'Le PRM compte $prmLength chiffres';
    return null;
  }

  String? _validateKw(String? value) {
    final kw = _parseKw(value ?? '');
    if (kw == null) return 'Saisissez la puissance crête de vos panneaux';
    if (kw <= 0 || kw > 1000) return 'Entre 0 et 1 000 kWc';
    if (!RegExp(r'^\d+([.,]\d{1,2})?$').hasMatch(value!.trim())) return '2 décimales au plus';
    return null;
  }

  Future<void> _submit() async {
    if (_submitting || !_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final meter = await ref.read(metersRepositoryProvider).create(
            prm: _prm.text,
            direction: _direction,
            address: _address!.label,
            peakKw: _direction == MeterDirection.production ? _parseKw(_peakKw.text) : null,
          );
      ref.invalidate(metersProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Compteur ajouté : ${meter.address}')),
      );
      context.pop();
    } catch (e) {
      if (mounted) setState(() => _error = errorMessage(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(authControllerProvider).value!.role;
    final directions = allowedDirections(role);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajouter un compteur')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (directions.length > 1) ...[
                    Text('Type de compteur', style: theme.textTheme.titleSmall),
                    const SizedBox(height: 8),
                    SegmentedButton<MeterDirection>(
                      segments: const [
                        ButtonSegment(
                          value: MeterDirection.consumption,
                          icon: Icon(Icons.home_outlined),
                          label: Text('Consommation'),
                        ),
                        ButtonSegment(
                          value: MeterDirection.production,
                          icon: Icon(Icons.solar_power_outlined),
                          label: Text('Production'),
                        ),
                      ],
                      selected: {_direction},
                      showSelectedIcon: false,
                      onSelectionChanged: (s) => setState(() => _direction = s.first),
                    ),
                    const SizedBox(height: 24),
                  ] else ...[
                    Text(
                      _direction == MeterDirection.production
                          ? 'Compteur de production (panneaux solaires)'
                          : 'Compteur de consommation',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 24),
                  ],
                  TextFormField(
                    controller: _prm,
                    decoration: const InputDecoration(
                      labelText: 'Numéro PRM',
                      helperText: '14 chiffres : touche « + » du Linky, ou « PRM / PDL » sur la facture',
                      helperMaxLines: 2,
                      prefixIcon: Icon(Icons.electric_meter_outlined),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(prmLength),
                    ],
                    validator: _validatePrm,
                  ),
                  const SizedBox(height: 16),
                  Autocomplete<AddressSuggestion>(
                    optionsBuilder: _suggest,
                    displayStringForOption: (a) => a.label,
                    onSelected: (a) => setState(() {
                      _address = a;
                      _addressText = a.label;
                    }),
                    fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          labelText: 'Adresse du compteur',
                          helperText: 'Commencez à taper puis choisissez dans la liste',
                          prefixIcon: const Icon(Icons.place_outlined),
                          errorText: _addressServiceError,
                        ),
                        onChanged: (text) => _addressText = text,
                        validator: (_) => (_address == null || _addressText != _address!.label)
                            ? 'Choisissez une adresse dans la liste'
                            : null,
                      );
                    },
                  ),
                  if (_direction == MeterDirection.production) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _peakKw,
                      decoration: const InputDecoration(
                        labelText: 'Puissance crête (kWc)',
                        helperText: 'Indiquée sur le contrat ou la facture de votre installation',
                        prefixIcon: Icon(Icons.solar_power_outlined),
                        suffixText: 'kWc',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: _validateKw,
                    ),
                  ],
                  const SizedBox(height: 24),
                  if (_error != null) ...[FormError(_error!), const SizedBox(height: 16)],
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox.square(
                            dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Ajouter le compteur'),
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
