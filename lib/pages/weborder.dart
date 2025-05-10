import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/widgets/orderlist.dart';

class WebOrder extends StatefulWidget {
  const WebOrder({super.key});

  @override
  State<WebOrder> createState() => _WebOrderState();
}

class _WebOrderState extends State<WebOrder> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _listPesanan = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    final orderId = uri.queryParameters['order_id'];
    if (orderId != null && orderId.isNotEmpty) {
      _controller.text = orderId;
      _loadPesanan(orderId);
    }
  }

  Future<void> _loadPesanan(String orderId) async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await ApiService().getTransaksiByOrderId(orderId);
      setState(() {
        _listPesanan = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _listPesanan = []; // Clear search results
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hitam,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(
                'img/homepagebackground.png',
                fit: BoxFit.fill,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 125,
                  margin: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  child: Image.asset("img/logolentera.png", fit: BoxFit.cover),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 20,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: AppColors.putih,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextField(
                          style: const TextStyle(fontFamily: "Poppins"),
                          controller: _controller,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Masukkan Order ID",
                            suffixIcon:
                                _controller.text.isNotEmpty
                                    ? IconButton(
                                      onPressed: _clearSearch,
                                      icon: const Icon(FontAwesomeIcons.xmark),
                                    )
                                    : null,
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.biru,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.biru,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          onPressed: () async {
                            await _loadPesanan(_controller.text.trim());
                          },
                          child: const Text(
                            "Cari Pesanan",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child:
                              _loading
                                  ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                  : _listPesanan.isEmpty
                                  ? Center(
                                    child: Text(
                                      "Data tidak ditemukan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                  : OrderList(pesanan: _listPesanan),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
