import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/persistence.dart';
import 'core/settings.dart';

Future<void> main() async {
  // Web: real paths (/apuzzle/?p=…, the share link format) instead of #/ routes.
  usePathUrlStrategy();
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
