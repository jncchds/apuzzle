import 'package:apuzzle/app.dart';
import 'package:apuzzle/core/persistence.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('home screen lists puzzle types', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = await GameStore.open();
    await tester.pumpWidget(MultiProvider(
      providers: [
        Provider.value(value: store),
        ChangeNotifierProvider(create: (_) => Settings(store.prefs)),
      ],
      child: const APuzzleApp(),
    ));
    expect(find.text('APuzzle by CHDS'), findsOneWidget);
    expect(find.text('Sun & Moon'), findsOneWidget);
  });
}
