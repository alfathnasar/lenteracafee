// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../model/pesanan.dart';
import '../model/session_data.dart';
import '../utils/web_helper_stub.dart'
    if (dart.library.html) '../utils/web_helper.dart';

class MidtransPaymentPage extends StatefulWidget {
  final int totalBayar;
  final String namaPemesan;
  final String orderId;

  const MidtransPaymentPage({
    super.key,
    required this.namaPemesan,
    required this.totalBayar,
    required this.orderId,
  });

  @override
  State<MidtransPaymentPage> createState() => _MidtransPaymentPageState();
}

class _MidtransPaymentPageState extends State<MidtransPaymentPage> {
  WebViewController? controller;
  late List<Pesanan> keranjangLocal;
  Future<void> launchUrl(Uri uri) async {
    if (!await launchUrlString(
      uri.toString(),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $uri';
    }
  }

  @override
  void initState() {
    super.initState();
    keranjangLocal =
        keranjangSementara
            .map(
              (item) => Pesanan(
                idItem: item.idItem,
                item: item.item,
                harga: item.harga,
                jumlah: item.jumlah,
                kategori: item.kategori,
                keterangan: item.keterangan,
                transaksi: item.transaksi,
                metodePembayaran: item.metodePembayaran,
                status: item.status,
                mejaID: item.mejaID,
                orderId: item.orderId,
              ),
            )
            .toList();
    keranjangSementara.clear();
    fetchSnapToken();
  }

  List<Map<String, dynamic>> generateItemDetails(List<Pesanan> pesananList) {
    return pesananList.map((pesanan) {
      return {
        'id': pesanan.idItem,
        'price': int.parse(pesanan.harga),
        'quantity': pesanan.jumlah,
        'name': '${pesanan.item} ${pesanan.keterangan}',
      };
    }).toList();
  }

  Future<void> fetchSnapToken() async {
    final int grossAmount = widget.totalBayar;
    final Map<String, dynamic> customerDetails = {
      'first_name': widget.namaPemesan,
    };
    final List<Map<String, dynamic>> itemDetails = generateItemDetails(
      keranjangLocal,
    );

    try {
      final response = await http.post(
        Uri.parse('https://lenteracafee.shop/API/midtrans.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order_id': widget.orderId,
          'gross_amount': grossAmount,
          'customer_details': customerDetails,
          'item_details': itemDetails,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final snapToken = data['token'];

        if (snapToken != null) {
          //SANDBOX
          // final snapUrl =
          //     'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken';

          //PRODUCTION
          final snapUrl = 'https://app.midtrans.com/snap/v2/vtweb/$snapToken';

          if (kIsWeb) {
            openMidtransSnap(snapUrl);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Silakan lanjutkan pembayaran di tab baru'),
              ),
            );
            Navigator.pop(context, true); // Kembali ke halaman sebelumnya
          } else {
            final newController =
                WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onNavigationRequest: (request) {
                        final url = request.url;
                        debugPrint('Navigating to: $url');

                        if (url.contains('status_code=') &&
                            url.contains('transaction_status=')) {
                          // Redirect to your custom URL
                          final uri = Uri.parse(url);
                          final orderId = uri.queryParameters['order_id'];
                          final statusCode = uri.queryParameters['status_code'];
                          final transactionStatus =
                              uri.queryParameters['transaction_status'];

                          // final redirectUrl =
                          //     Uri.https('lenteracafee.shop', '/order', {
                          //       'order_id': orderId,
                          //       'status_code': statusCode,
                          //       'transaction_status': transactionStatus,
                          //     });

                          final redirectUrl = Uri.http(
                            'localhost:59531', // atau '10.0.2.2:8000' jika dari emulator Android
                            '/order',
                            {
                              'order_id': orderId,
                              'status_code': statusCode,
                              'transaction_status': transactionStatus,
                            },
                          );

                          // Buka URL baru (misalnya menggunakan launchUrl atau Navigator)
                          // Jika ingin menggunakan browser:
                          launchUrl(redirectUrl);

                          return NavigationDecision
                              .prevent; // Hentikan navigasi WebView
                        }

                        return NavigationDecision.navigate;
                      },
                    ),
                  )
                  ..loadRequest(Uri.parse(snapUrl));

            setState(() {
              controller = newController;
            });
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menghubungi server')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body:
          kIsWeb
              ? const Center(child: Text("Membuka pembayaran di tab baru..."))
              : controller == null
              ? const Center(child: CircularProgressIndicator())
              : WebViewWidget(controller: controller!),
    );
  }
}
