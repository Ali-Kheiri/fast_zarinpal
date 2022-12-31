part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentStarted extends PaymentEvent {}
class PaymentClosed extends PaymentEvent{}
class NavigateFromPaymentClicked extends PaymentEvent {
  final bool isPaymentSuccess;
  final String? refID;
  final PaymentRequest paymentRequest;

  const NavigateFromPaymentClicked(
      {required this.isPaymentSuccess,
      required this.refID,
      required this.paymentRequest});
}
