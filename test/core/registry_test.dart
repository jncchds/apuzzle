import 'package:apuzzle/core/registry.dart';
import 'package:apuzzle/core/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('every game is in exactly one home-screen group', () {
    final grouped = [for (final c in puzzleCategories) ...c.types.map((t) => t.id)];
    expect(grouped.toSet().length, grouped.length);
    expect(grouped.toSet(), puzzleTypes.map((t) => t.id).toSet());
    expect(puzzleCategories.map((c) => c.id).toSet().length, puzzleCategories.length);
  });

  test('collapsed groups are remembered between runs', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final settings = Settings(prefs);
    expect(settings.isCollapsed('paths'), isFalse);
    settings.toggleCollapsed('paths');
    settings.toggleCollapsed('casual');
    settings.toggleCollapsed('casual');
    final again = Settings(prefs);
    expect(again.isCollapsed('paths'), isTrue);
    expect(again.isCollapsed('casual'), isFalse);
  });
}
