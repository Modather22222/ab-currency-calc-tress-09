import 'package:flutter/foundation.dart';

/// In-memory state for the user's favorite currency codes (ISO 4217).
class FavoritesStore extends ChangeNotifier {
  FavoritesStore({
    Set<String> initialFavorites = const <String>{'EUR', 'JPY', 'GBP'},
  }) : _codes = <String>{...initialFavorites};

  final Set<String> _codes;

  /// Currently favorite currency codes (read-only view).
  Set<String> get codes => Set<String>.unmodifiable(_codes);

  bool isFavorite(String code) => _codes.contains(code);

  void toggle(String code) {
    if (isFavorite(code)) {
      _codes.remove(code);
    } else {
      _codes.add(code);
    }
    notifyListeners();
  }
}
