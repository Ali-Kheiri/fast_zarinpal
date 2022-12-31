import 'package:fast_zarinpal/fast_zarinpal.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return MaterialApp(
      title: 'Fast Zarinpal Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FastZarinPal(
          callback: 'yourdomain.com',
          merchantID: 'e8181811-8181-8181-bc31-813fe9818181',
          paymentTitle: 'خرید اشتراک ماهانه ',
          priceToPay: 125000,
          totalPurchaseAmount: 150000,
          dicount: 25000,
          onPaymentFailedWidgets: (amount) =>
              FailedPaymentWidget(themeData: themeData),
          onSuccessWidgets: (amount, refID) {
         
            return const SuccessPaymentWidget();
            
          }),
    );
  }
}

class SuccessPaymentWidget extends StatelessWidget {
  const SuccessPaymentWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.check,
          color: Colors.green,
        ),
        const Text('پرداخت شما موفق بود ! '),
        const SizedBox(
          height: 12,
        ),
        const Divider(),
        TextButton(
            onPressed: () {}, child: const Text('بازگشت به صفحه فروشگاه')),
      ],
    );
  }
}

class FailedPaymentWidget extends StatelessWidget {
  const FailedPaymentWidget({
    Key? key,
    required this.themeData,
  }) : super(key: key);

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.error,
          color: themeData.errorColor,
        ),
        Text(
          'پرداخت شما ناموفق بود :(',
          style: themeData.textTheme.subtitle1!.copyWith(
            color: themeData.errorColor,
          ),
        ),
        const Divider(),
        TextButton(onPressed: () {}, child: const Text('بازگشت و تلاش مجدد')),
      ],
    );
  }
}
