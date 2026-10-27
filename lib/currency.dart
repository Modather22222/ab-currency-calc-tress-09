import 'package:flutter/foundation.dart';

/// One entry of the hardcoded currency catalog. Rates are static sample data
/// quoted per 1 USD and never change at runtime.
@immutable
class Currency {
  const Currency({
    required this.code,
    required this.name,
    required this.flag,
    required this.ratePerUsd,
  });

  final String code;
  final String name;
  final String flag;

  /// How many units of this currency 1 USD buys.
  final double ratePerUsd;

  /// Converts [amount] from the [from] currency into this currency.
  double convert(double amount, Currency from) =>
      amount / from.ratePerUsd * ratePerUsd;
}

const List<Currency> kCurrencies = <Currency>[
  Currency(code: 'USD', name: 'US Dollar', flag: '🇺🇸', ratePerUsd: 1.0),
  Currency(code: 'EUR', name: 'Euro', flag: '🇪🇺', ratePerUsd: 0.92),
  Currency(code: 'GBP', name: 'British Pound', flag: '🇬🇧', ratePerUsd: 0.79),
  Currency(code: 'JPY', name: 'Japanese Yen', flag: '🇯🇵', ratePerUsd: 149.50),
  Currency(code: 'CAD', name: 'Canadian Dollar', flag: '🇨🇦', ratePerUsd: 1.36),
  Currency(code: 'AUD', name: 'Australian Dollar', flag: '🇦🇺', ratePerUsd: 1.52),
  Currency(code: 'CHF', name: 'Swiss Franc', flag: '🇨🇭', ratePerUsd: 0.88),
  Currency(code: 'CNY', name: 'Chinese Yuan', flag: '🇨🇳', ratePerUsd: 7.24),
  Currency(code: 'INR', name: 'Indian Rupee', flag: '🇮🇳', ratePerUsd: 83.20),
  Currency(code: 'BRL', name: 'Brazilian Real', flag: '🇧🇷', ratePerUsd: 4.97),
  Currency(code: 'MXN', name: 'Mexican Peso', flag: '🇲🇽', ratePerUsd: 17.10),
  Currency(code: 'KRW', name: 'South Korean Won', flag: '🇰🇷', ratePerUsd: 1318.50),
];

/// Formats [value] with thousands separators and a sensible number of
/// decimals: 2 for values >= 1, otherwise 4 (or 6 for tiny cross rates).
String formatAmount(double value) {
  final String sign = value.isNegative ? '-' : '';
  final double abs = value.abs();
  final int digits = abs >= 1 ? 2 : (abs >= 0.01 ? 4 : 6);
  final String fixed = abs.toStringAsFixed(digits);
  final int dot = fixed.indexOf('.');
  final String intPart = dot < 0 ? fixed : fixed.substring(0, dot);
  final String fracPart = dot < 0 ? '' : fixed.substring(dot);
  final RegExp group = RegExp(r'\B(?=(\d{3})+(?!\d))');
  return '$sign${intPart.replaceAllMapped(group, (Match match) => ',')}$fracPart';
}
