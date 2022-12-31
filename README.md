
# Fast_Zarinpal

Quick implementation of Zarin Pal payments with Fast_ZarinPal


![Logo](https://s5.uupload.ir/files/seraaj/Flutter_Downloads/FlutterPlus.ir/fast_ZarinPal.png)

# 🔧 Installation

   
## 1.Add Fast Zarinpal  to your project
```bash
flutter pub add fast_zarinpal
```
## 2.Add your callback in AndroidManifest.xml 
Add the following code in the Android Manifest file.  `android/app/main/AndroidManifest.xml` 
```xml
<intent-filter>
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<category android:name="android.intent.category.BROWSABLE" />
<data 
android:scheme="payment"
android:host='yourdomain.com' />
</intent-filter>
```
❓You can enter your desired address instead of `yourdomain.com`.
If this address is not registered for another application, it will not be a problem.
For reference, the example app's AndroidManifest.xml file can be found [here]('https://github.').
## Example

```dart
 FastZarinPal(
          callback: 'yourdomain.com',
          merchantID: 'e8188181-8181-8181-8181-818181818181',
          paymentTitle: 'خرید اشتراک ماهانه ',
          priceToPay: 125000,
          totalPurchaseAmount: 150000,
          dicount: 25000,
          onPaymentFailedWidgets: (amount) =>
              FailedPaymentWidget(themeData: themeData),
          onSuccessWidgets: (amount, refID) {
            return const SuccessPaymentWidget();
          },
),
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
```


## Feedback

If you have any feedback, please reach out to us at info@flutterplus.ir


