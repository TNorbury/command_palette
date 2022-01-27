import 'package:command_palette/src/utils/filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    "Filter matches",
    () {
      var result = Filter.matchesFuzzy("cl cmd p", "Close Command Palette");

      expect(result != null, true);

      result = Filter.matchesFuzzy("ccp", "Close Command Palette");

      expect(result != null, true);

      result = Filter.matchesFuzzy("ccccp", "Close Command Palette");

      expect(result, null);
    },
  );
}
