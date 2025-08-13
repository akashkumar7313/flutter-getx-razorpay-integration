import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentService {
  late Razorpay _razorpay;

  void initRazorpay({
    required BuildContext context,
    required double amount,
    required String userPhone,
    required String userEmail,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (
      PaymentSuccessResponse response,
    ) {
      debugPrint("✅ Payment Success: ${response.paymentId}");
      onSuccess();
    });

    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (
      PaymentFailureResponse response,
    ) {
      debugPrint("❌ Payment Failed: ${response.code} - ${response.message}");
      onFailure();
    });

    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (
      ExternalWalletResponse response,
    ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("External Wallet Selected: ${response.walletName}"),
        ),
      );
    });

    var options = {
      'key': 'rzp_test_Ua8S2MVZ2PqKFQ',
      'amount': (amount * 100).toInt(), // ₹ → paise
      'name': 'Your Store',
      'description': 'Test Purchase',
      'prefill': {'contact': userPhone, 'email': userEmail},
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void dispose() {
    _razorpay.clear();
  }
}
