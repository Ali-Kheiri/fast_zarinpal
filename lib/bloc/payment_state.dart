part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class ShowPaymentResultScreen extends PaymentState {
  final bool isPaymentSuccess;
  final String? refID;
  final String description;
  final num amount;

  const ShowPaymentResultScreen(
      {
        required this.refID, 
        required this.isPaymentSuccess,
      required this.description,
      required this.amount});
  @override
  List<Object> get props => [isPaymentSuccess, description, amount];
}

class SuccessAddPaymentHistory extends PaymentState {
  final bool isPaymentSuccessAdded;
  final bool isPaymentSuccess;
  final String description;
  final num amount;
  const SuccessAddPaymentHistory(
      {required this.isPaymentSuccess,
      required this.description,
      required this.amount,
      required this.isPaymentSuccessAdded});
  @override
  List<Object> get props =>
      [isPaymentSuccess, isPaymentSuccessAdded, description];
}

class ErrorAddPaymentHistory extends PaymentState {
  final bool isPaymentSuccessAdded;
  final bool isPaymentSuccess;
  final String description;
  final num amount;
  const ErrorAddPaymentHistory(
      {required this.isPaymentSuccess,
      required this.description,
      required this.amount,
      required this.isPaymentSuccessAdded});
  @override
  List<Object> get props =>
      [isPaymentSuccessAdded, isPaymentSuccess, description];
}

class LoadingPayment extends PaymentState {}

class ShowCartScreen extends PaymentState {}

class CloseFromPayment extends PaymentState{}