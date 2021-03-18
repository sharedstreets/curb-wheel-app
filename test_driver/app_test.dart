import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('CurbWheel', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final gestureDetector = find.byValueKey('gestureDetector');

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    /*
    test('splash page tap', () async {
      // First, tap the button.
      await driver.tap(gestureDetector);

      // Then, verify the counter text is incremented by 1.
      //expect(await find.byType(ProjectListScreen()), findsOneWidget);
    })*/
  });
}