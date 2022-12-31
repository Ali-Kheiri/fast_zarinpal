library fast_zarinpal;

/// A Calculator.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zarinpal/zarinpal.dart';

import 'bloc/payment_bloc.dart';

class FastZarinPal extends StatefulWidget {
  ///The amount that will actually be paid
  final double priceToPay;
  //Total Amount
  final double totalPurchaseAmount;
  ///If the discount is empty, it will be considered zero. In any case, if there is a discount, you must subtract it from "priceToPay".
  final double? dicount;
  ///The callback you defined in the AndroidManifest.xml file. It can be any desired value.
  final String callback;
  ///In case of successful payment, what widgets should be displayed?
  final Widget Function(String amount, String refID) onSuccessWidgets;
  ///What widgets should be displayed in case of unsuccessful payment?
  final Widget Function(String amount) onPaymentFailedWidgets;
  ///Merchant ID You can save in a separate const.dart file.
  final String merchantID;
  ///The title displayed on the online checkout page.
  final String paymentTitle;
  /// A title displayed on the payment result page.  default value is 'نتیجه پرداخت',
  final  String paymentResultTitle;
   const FastZarinPal(
      {super.key,
      this.paymentResultTitle = 'نتیجه پرداخت', 
      required this.priceToPay,
      required this.paymentTitle,
      required this.merchantID,
      this.dicount,
      required this.totalPurchaseAmount,
      required this.onSuccessWidgets,
      required this.onPaymentFailedWidgets,
      required this.callback});

  @override
  State<FastZarinPal> createState() => _FastZarinPalState();
}

// final PaymentBloc paymentBloc = PaymentBloc(selectedSubMode);
class _FastZarinPalState extends State<FastZarinPal> {
  final TextEditingController discountCodeTextEditing = TextEditingController();
  PaymentBloc paymentBloc = PaymentBloc();

  late PaymentRequest paymentRequest;

  bool isLoading = false;
  bool isLoadingPay = false;
  Uri? payUri;
  @override
  void dispose() {
    discountCodeTextEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initPlatformStateForUriUniLinks();
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) {
            paymentBloc.add(PaymentStarted());
            paymentBloc.stream.forEach((state) {
              if (state is CloseFromPayment) {
                Navigator.of(context).pop();
              }
            });
            return paymentBloc;
          },
          child: BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              if (state is ShowPaymentResultScreen ||
                  state is SuccessAddPaymentHistory ||
                  state is ErrorAddPaymentHistory) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Text(
                          'نتیجه پرداخت',
                          style: themeData.textTheme.subtitle1,
                        ),
                        const SizedBox(
                          height: 26,
                        ),
                        state is ShowPaymentResultScreen
                            ? state.isPaymentSuccess
                                ? widget.onSuccessWidgets(
                                    state.amount.toString(), state.refID!)
                                : !state.isPaymentSuccess
                                    ? widget.onPaymentFailedWidgets(
                                        state.amount.toString())
                                    : const SizedBox()
                            : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is LoadingPayment || state is CloseFromPayment) {
                if (state is CloseFromPayment) {
                  debugPrint('Close From Payment ! :/ ');
                }
                return const Center(child: AnimtedLoading());
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(12),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 12,
                              ),
                            ]),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('جزئیات خرید'),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                            color: ThemeColors.errorColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 12,
                                        )),
                                  ),
                                ]),
                            Row(
                              children: [
                                Icon(
                                  Icons.sell,
                                  color: themeData.primaryColor,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(widget.paymentTitle),
                              ],
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 36,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text('مبلغ  کل خرید'),
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${widget.totalPurchaseAmount.toInt()} تومان',
                                                style: themeData
                                                    .textTheme.caption!
                                                    .copyWith(
                                                  color:
                                                      const Color(0xff72A3E4),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                      const Divider(
                                        height: 16,
                                        thickness: 1,
                                      ),
                                      Row(
                                        children: [
                                          const Text('تخفیف'),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  '${widget.dicount != null ? widget.dicount!.toInt() : 0} تومان',
                                                  style: themeData
                                                      .textTheme.caption!
                                                      .copyWith(
                                                    color:
                                                        ThemeColors.errorColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'مبلغ پرداختی ',
                                            style: themeData
                                                .textTheme.subtitle1!
                                                .copyWith(
                                              color: const Color(0xff3ECB6E),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              widget.priceToPay
                                                  .toInt()
                                                  .toString()
                                                  .seRagham(),
                                              style: themeData
                                                  .textTheme.headline6!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w900),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          const Text('تومان')
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Expanded(
                              child: SizedBox(),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color(0xff34CC73))),
                                    onPressed: () async {
                                      setState(() {
                                        paymentRequest = PaymentRequest()
                                          ..setIsSandBox(
                                              true) // if your application is in developer mode, then set the sandBox as True otherwise set sandBox as false
                                          ..setMerchantID(widget.merchantID)
                                          ..setCallbackURL(
                                              "payment://${widget.callback}");
                                        //The callback can be an android scheme or a website URL, you and can pass any data with The callback for both scheme and  URL
                                      });

                                      paymentRequest
                                          .setAmount(widget.priceToPay);

                                      paymentRequest
                                          .setDescription(widget.paymentTitle);
                                      // Call Start payment
                                      setState(() {
                                        isLoadingPay = true;
                                      });
                                      ZarinPal().startPayment(
                                        paymentRequest,
                                        (status, paymentGatewayUri) async {
                                          if (status == 100) {
                                            launchUrl(
                                              Uri.parse(paymentGatewayUri!),
                                              mode: LaunchMode
                                                  .externalNonBrowserApplication,
                                            );
                                          }
                                        },
                                      );
                                    },
                                    child: isLoadingPay
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 5,
                                              ),
                                            ),
                                          )
                                        : const Text('پرداخت آنلاین'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  initPlatformStateForUriUniLinks() async {
    uriLinkStream.listen((Uri? uri) {
      var urlQuery = uri!.queryParametersAll.entries.toList();
      if (urlQuery[1].value[0] == "OK") {
        ZarinPal().verificationPayment(
            urlQuery[1].value[0], urlQuery[0].value[0], paymentRequest,
            (isPaymentSuccess, refID, paymentRequest) {
          if (isPaymentSuccess) {
            paymentBloc.add(
              NavigateFromPaymentClicked(
                  paymentRequest: paymentRequest,
                  isPaymentSuccess: isPaymentSuccess,
                  refID: refID),
            );
          }
        });
      } else if (urlQuery[1].value[0] == "NOK") {
        paymentBloc.add(
          NavigateFromPaymentClicked(
              paymentRequest: paymentRequest,
              isPaymentSuccess: false,
              refID: 'Undefined!'),
        );
      }
    }, onError: (error) {
      debugPrint('Error ==========================');
    });
  }
}

class ThemeColors {
  static const Color secoundryColor = Colors.white;
  static const Color primaryColor = Color(0xffFCBE11);

  // ignore: use_full_hex_values_for_flutter_colors
  static const Color primayTextColor = Color(0xff4210752);
  static const Color errorColor = Color(0xffBD272D);
  static const Color profileIconsColor = Color(0xffAFAFAF);
  static const Color successColor = Color(0xff1A8755);
}

class AnimtedLoading extends StatelessWidget {
  const AnimtedLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 4,
        color: Colors.green,
      ),
    );
  }
}
