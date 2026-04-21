import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/models/app_cache.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppCache', () {
    late AppCache cache;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      cache = AppCache();
    });

    test('returns defaults when keys are missing', () async {
      expect(await cache.isUserLoggedIn(), isFalse);
      expect(await cache.getThemeMode(), 'light');
      expect(await cache.getColorSelection(), 0);
      expect(await cache.getLastTab(), 0);
    });

    test('persists and restores values', () async {
      await cache.cacheUser();
      await cache.cacheThemeMode('dark');
      await cache.cacheColorSelection(2);
      await cache.cacheLastTab(1);

      expect(await cache.isUserLoggedIn(), isTrue);
      expect(await cache.getThemeMode(), 'dark');
      expect(await cache.getColorSelection(), 2);
      expect(await cache.getLastTab(), 1);
    });

    test('invalidate logs out but keeps other settings', () async {
      await cache.cacheUser();
      await cache.cacheThemeMode('dark');

      await cache.invalidate();

      expect(await cache.isUserLoggedIn(), isFalse);
      expect(await cache.getThemeMode(), 'dark');
    });
  });
}
