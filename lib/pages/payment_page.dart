import 'package:flutter/material.dart';
import 'package:futsal_now_mobile/pages/midtrans_payment_page.dart';

class PaymentPage extends StatefulWidget {
  final String snapToken;
  final String orderNumber;

  const PaymentPage({super.key, required this.snapToken, required this.orderNumber});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Future<void> _getSnapTokenFromServer() async {
    _openMidtransPaymentPage();
  }

  // Fungsi untuk membuka halaman pembayaran Snap.js
  void _openMidtransPaymentPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MidtransPaymentPage(snapToken: widget.snapToken),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _getSnapTokenFromServer,
          child: const Text('Proses Pembayaran'),
        ),
      ),
    );
  }
}
