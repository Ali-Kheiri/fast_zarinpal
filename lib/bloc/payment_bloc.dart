import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:zarinpal/zarinpal.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<PaymentEvent>((event, emit) async {
      if (event is PaymentStarted) {
        emit(ShowCartScreen());
      } else if (event is PaymentClosed) {
        emit(CloseFromPayment());
      } else if (event is NavigateFromPaymentClicked) {
        emit(LoadingPayment());
        final bool isPaymentSuccess = event.isPaymentSuccess;
        final String description = event.paymentRequest.description!;
        final num amount = event.paymentRequest.amount!;

        emit(ShowPaymentResultScreen(
          amount: amount,
          refID: event.refID,
          description: description,
          isPaymentSuccess: isPaymentSuccess,
        ));
      }
    });
  }
}
