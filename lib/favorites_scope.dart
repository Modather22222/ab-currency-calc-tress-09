import 'package:flutter/material.dart';

import 'favorites_store.dart';

/// Exposes the app-wide [FavoritesStore] to the widget tree and rebuilds
/// dependents whenever the favorites change.
class FavoritesScope extends InheritedNotifier<FavoritesStore> {
  const FavoritesScope({
    super.key,
    required FavoritesStore store,
    required super.child,
  }) : super(notifier: store);

  static FavoritesStore of(BuildContext context) {
    final FavoritesScope? scope =
        context.dependOnInheritedWidgetOfExactType<FavoritesScope>();
    assert(scope != null, 'No FavoritesScope found in the widget tree.');
    return scope!.notifier!;
  }
}
