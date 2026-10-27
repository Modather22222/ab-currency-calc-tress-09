import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'currency.dart';
import 'favorites_scope.dart';
import 'favorites_store.dart';

class ConvertPage extends StatefulWidget {
  const ConvertPage({super.key});

  @override
  State<ConvertPage> createState() => _ConvertPageState();
}

class _ConvertPageState extends State<ConvertPage> {
  final TextEditingController _amountController =
      TextEditingController(text: '100');
  Currency _from = kCurrencies.first;
  Currency _to = kCurrencies[1];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double? get _amount =>
      double.tryParse(_amountController.text.trim().replaceAll(',', ''));

  double? get _result {
    final double? amount = _amount;
    return amount == null ? null : _to.convert(amount, _from);
  }

  void _swap() {
    setState(() {
      final Currency previous = _from;
      _from = _to;
      _to = previous;
    });
  }

  Widget _buildDropdown({
    required String label,
    required Currency value,
    required ValueChanged<Currency?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButton<Currency>(
        value: value,
        isExpanded: true,
        isDense: true,
        underline: const SizedBox.shrink(),
        items: <DropdownMenuItem<Currency>>[
          for (final Currency currency in kCurrencies)
            DropdownMenuItem<Currency>(
              value: currency,
              child: Text(
                '${currency.flag} ${currency.code} — ${currency.name}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FavoritesStore favorites = FavoritesScope.of(context);
    final double? result = _result;
    final bool isFavorite = favorites.isFavorite(_to.code);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Calc'),
        actions: <Widget>[
          IconButton(
            tooltip: isFavorite
                ? 'Remove ${_to.code} from favorites'
                : 'Add ${_to.code} to favorites',
            onPressed: () => favorites.toggle(_to.code),
            icon: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  hintText: 'e.g. 250',
                  prefixText: '${_from.code} ',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: _buildDropdown(
                      label: 'From',
                      value: _from,
                      onChanged: (Currency? currency) => setState(() {
                        if (currency != null) _from = currency;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: IconButton.filledTonal(
                      tooltip: 'Swap currencies',
                      onPressed: _swap,
                      icon: const Icon(Icons.swap_horiz),
                    ),
                  ),
                  Expanded(
                    child: _buildDropdown(
                      label: 'To',
                      value: _to,
                      onChanged: (Currency? currency) => setState(() {
                        if (currency != null) _to = currency;
                      }),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Converted amount',
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 8),
                      Text(
                        result == null
                            ? 'Enter a valid amount'
                            : '${formatAmount(result)} ${_to.code}',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1 ${_from.code} = '
                        '${formatAmount(_to.ratePerUsd / _from.ratePerUsd)} '
                        '${_to.code} · static sample rates',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Quick convert to favorites',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (favorites.codes.isEmpty)
                Text(
                  'No favorites yet — tap the star above or add some on the '
                  'Favorites tab.',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: <Widget>[
                    for (final Currency currency in kCurrencies)
                      if (favorites.isFavorite(currency.code))
                        ActionChip(
                          avatar: Text(currency.flag),
                          label: Text(currency.code),
                          tooltip: 'Convert to ${currency.code}',
                          onPressed: () => setState(() => _to = currency),
                        ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
