import 'package:apuzzle/core/value_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pencil marks stay under a value and show again once it is removed', () {
    final marked = const CellValue().toggleMark(1).toggleMark(3);
    final placed = marked.withValue(2);
    expect(placed.value, 2);
    expect(placed.marks, {1, 3});

    final back = placed.withValue(null);
    expect(back.value, isNull);
    expect(back.marks, {1, 3});

    // The eraser takes the value first, then the marks.
    expect(placed.erased().marks, {1, 3});
    expect(placed.erased().erased().marks, isEmpty);

    // Round trip keeps both.
    final json = CellValue.fromJson(placed.toJson());
    expect(json.value, 2);
    expect(json.marks, {1, 3});
  });
}
