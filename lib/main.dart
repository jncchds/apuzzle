import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/persistence.dart';
import 'core/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await GameStore.open();
  runApp(MultiProvider(
    providers: [
      Provider.value(value: store),
      ChangeNotifierProvider(create: (_) => Settings(store.prefs)),
    ],
    child: const APuzzleApp(),
  ));
}
