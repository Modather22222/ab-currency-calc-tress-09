import 'package:flutter/material.dart';

import 'convert_page.dart';
import 'favorites_page.dart';
import 'favorites_scope.dart';
import 'favorites_store.dart';

void main() {
  runApp(const CurrencyCalcApp());
}

class CurrencyCalcApp extends StatefulWidget {
  const CurrencyCalcApp({super.key});

  @override
  State<CurrencyCalcApp> createState() => _CurrencyCalcAppState();
}

class _CurrencyCalcAppState extends State<CurrencyCalcApp> {
  final FavoritesStore _favorites = FavoritesStore();

  @override
  void dispose() {
    _favorites.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FavoritesScope(
      store: _favorites,
      child: MaterialApp(
        title: 'Currency Calc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.teal,
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: const <Widget>[ConvertPage(), FavoritesPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (int index) => setState(() => _tab = index),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.currency_exchange),
            label: 'Convert',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border),
            selectedIcon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
