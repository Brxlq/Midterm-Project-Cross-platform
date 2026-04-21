import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yummy/models/cart_manager.dart';
import 'package:yummy/models/order_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Order sampleOrder() {
    return Order(
      selectedSegment: {0},
      selectedTime: const TimeOfDay(hour: 9, minute: 30),
      selectedDate: DateTime(2026, 4, 20),
      name: 'Yerkebulan Sovet',
      items: [
        CartItem(
          id: 'addon-1',
          name: 'Extra driver access',
          price: 18,
          quantity: 1,
        ),
      ],
      vehicleName: 'Toyota Corolla',
      vehicleImageUrl: 'https://example.com/car.jpg',
      vehicleClass: 'Economy',
      baseRate: 14,
      rentalUnit: RentalUnit.hours,
      rentalLength: 3,
      discountAmount: 2.0,
      discountCode: 'ASTANA10',
    );
  }

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('persists reservations and restores after restart', () async {
    final manager = OrderManager();
    await manager.addOrder(sampleOrder());

    final restored = await OrderManager.loadSavedOrders();
    expect(restored.length, 1);
    expect(restored.first.vehicleName, 'Toyota Corolla');
    expect(restored.first.name, 'Yerkebulan Sovet');
    expect(restored.first.rentalLength, 3);
    expect(restored.first.items.length, 1);
    expect(restored.first.items.first.name, 'Extra driver access');
  });
}
