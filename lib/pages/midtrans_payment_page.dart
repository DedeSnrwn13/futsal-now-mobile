import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MidtransPaymentPage extends StatefulWidget {
  final String snapToken;

  const MidtransPaymentPage({super.key, required this.snapToken});

  @override
  _MidtransPaymentPageState createState() => _MidtransPaymentPageState();
}

class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Midtrans Payment'),
      ),
      body: InAppWebView(
        initialData: InAppWebViewInitialData(
          data: '''
            <html>
            <head>
              <meta name="viewport" content="width=device-width, initial-scale=1">
              <script type="text/javascript"
                      src="https://app.sandbox.midtrans.com/snap/snap.js"
                      data-client-key="SB-Mid-client-nbKmE9kEruK8vHAs"></script>
            </head>
            <body>
              <button id="pay-button" style="textalign: center; padding: 18px; color: blue;">Pay!</button>
              <script type="text/javascript">
                var payButton = document.getElementById('pay-button');
                payButton.addEventListener('click', function () {
                  snap.pay(${widget.snapToken});
                });
              </script>
            </body>
          </html>
          ''',
        ),
      ),
    );
  }
}
