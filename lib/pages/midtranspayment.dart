// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lenteracafe/model/pesanan.dart';
import 'package:lenteracafe/model/session_data.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void initState() {
    super.initState();
    fetchSnapToken();
  }

  List<Map<String, dynamic>> generateItemDetails(List<Pesanan> pesananList) {
    return pesananList.map((pesanan) {
      return {
        'id': pesanan.idItem,
        'price': int.parse(
          pesanan.harga,
        ), // Mengkonversi harga dari string ke integer
        'quantity': pesanan.jumlah,
        'name': '${pesanan.item} ${pesanan.keterangan}',
      };
    }).toList();
  }

  Future<void> fetchSnapToken() async {
    // Data untuk transaksi yang dikirim ke server PHP
    final int grossAmount = widget.totalBayar; // Nominal pembayaran
    final Map<String, dynamic> customerDetails = {
      'first_name': widget.namaPemesan,
    };
    final List<Map<String, dynamic>> itemDetails = generateItemDetails(
      keranjangSementara,
    );

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.20/lentera/API/midtrans.php'),
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
          final newController =
              WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onNavigationRequest: (request) {
                      debugPrint('Navigating to: ${request.url}');
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(
                  Uri.parse(
                    'https://app.sandbox.midtrans.com/snap/v2/vtweb/$snapToken',
                  ),
                );

          setState(() {
            controller = newController;
          });
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Token tidak ditemukan')));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghubungi server')));
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
      appBar: AppBar(title: Text("Pembayaran")),
      body:
          controller == null
              ? Center(child: CircularProgressIndicator())
              : WebViewWidget(controller: controller!),
    );
  }
}
