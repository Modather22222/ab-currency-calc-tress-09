import 'package:flutter/material.dart';

import 'currency.dart';
import 'favorites_scope.dart';
import 'favorites_store.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesStore favorites = FavoritesScope.of(context);
    final List<Currency> sorted = <Currency>[...kCurrencies]
      ..sort((Currency a, Currency b) {
        final int byFavorite = (favorites.isFavorite(a.code) ? 0 : 1)
            .compareTo(favorites.isFavorite(b.code) ? 0 : 1);
        if (byFavorite != 0) return byFavorite;
        return a.code.compareTo(b.code);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Favorites are shown first. Tap a star to add or remove.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          for (final Currency currency in sorted)
            ListTile(
              leading: Text(currency.flag,
                  style: const TextStyle(fontSize: 28)),
              title: Text('${currency.code} — ${currency.name}'),
              subtitle: Text(
                  '1 USD = ${formatAmount(currency.ratePerUsd)} ${currency.code}'),
              trailing: IconButton(
                tooltip: favorites.isFavorite(currency.code)
                    ? 'Remove ${currency.code} from favorites'
                    : 'Add ${currency.code} to favorites',
                onPressed: () => favorites.toggle(currency.code),
                icon: Icon(
                  favorites.isFavorite(currency.code)
                      ? Icons.star
                      : Icons.star_border,
                  color: favorites.isFavorite(currency.code)
                      ? Colors.amber
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
