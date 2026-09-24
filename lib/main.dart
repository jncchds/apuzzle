import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/persistence.dart';
import 'core/settings.dart';
import 'ui/puzzle_code_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await GameStore.open();
  final navigatorKey = GlobalKey<NavigatorState>();
  final messengerKey = GlobalKey<ScaffoldMessengerState>();
  ShareLinkHandler(navigatorKey: navigatorKey, messengerKey: messengerKey).start();
  runApp(MultiProvider(
    providers: [
      Provider.value(value: store),
      ChangeNotifierProvider(create: (_) => Settings(store.prefs)),
    ],
    child: APuzzleApp(navigatorKey: navigatorKey, messengerKey: messengerKey),
  ));
}
