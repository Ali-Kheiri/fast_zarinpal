import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fast_zarinpal/fast_zarinpal.dart';

void main() {
  test('adds one to input values', () {
    final fastZarinPal = FastZarinPal(
      callback: 'yourdomain.com',
      merchantID: 'testMID',
      onPaymentFailedWidgets: (amount) {
        return const Text('test -> payment failed');
      },
      onSuccessWidgets: (amount, refID) {
        return const Text('test -> success payment');
      },
      paymentTitle: 'payment title',
      priceToPay: 1,
      totalPurchaseAmount: 2,
      dicount: 0,
    );

    expect(fastZarinPal.totalPurchaseAmount, 2);
    expect(fastZarinPal.callback, 'yourdomain.com');
    expect(
        fastZarinPal.onSuccessWidgets, const Text('test -> success payment'));
    expect(fastZarinPal.priceToPay, 1);
  });
}
