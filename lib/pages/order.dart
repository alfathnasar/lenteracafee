// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/pages/midtranspayment.dart';
import 'package:lenteracafe/widgets/customdialog.dart';
import 'package:lenteracafe/widgets/header.dart';
import 'package:lenteracafe/widgets/keranjanglist.dart';
import 'package:lenteracafe/model/session_data.dart';
import 'package:lenteracafe/widgets/metodepembayaran.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  final String? mejaID;
  const Order({super.key, this.mejaID});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool isWaiting = false;
  final TextEditingController controller = TextEditingController();
  String nama = "";

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "";
    });
  }

  bool cekTransaksi() {
    for (var p in keranjangSementara) {
      if (p.transaksi == "Pengeluaran") {
        getUsername();
        return true;
      }
    }
    return false;
  }

  int getTotalPesanan() {
    int total = 0;
    for (var p in keranjangSementara) {
      total += int.parse(p.harga) * p.jumlah;
      if (p.transaksi == "Pengeluaran") {}
    }
    return total;
  }

  String formatRupiah(int harga) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(harga);
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
              children: [
                Header(keterangan: "Pesanan"),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.putih,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child:
                        keranjangSementara.isNotEmpty
                            ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: kIsWeb,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.biru,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      bottom: 10,
                                      right: 20,
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "Meja ${widget.mejaID}",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.putih,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !cekTransaksi(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          bottom: 10,
                                        ),
                                        child: Text(
                                          "Nama Pemesan",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 20,
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: TextField(
                                          controller: controller,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(width: 1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            enabledBorder:
                                                const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors.biru,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: nama != "",
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: 20,
                                                bottom: 10,
                                              ),
                                              child: Text(
                                                "Metode Pembayaran",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Poppins",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Metodepembayaran(
                                              onChanged: (val) {
                                                //_selectedPaymentMethod = val;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 20,
                                    bottom: 10,
                                  ),
                                  child: Text(
                                    !cekTransaksi()
                                        ? "Daftar Pesanan"
                                        : "Daftar Belanja",
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 60),
                                    child: ListView.builder(
                                      itemCount: keranjangSementara.length,
                                      itemBuilder: (context, index) {
                                        return Keranjanglist(
                                          pesanan: keranjangSementara[index],
                                          onUpdate: (newQty) {
                                            setState(() {
                                              keranjangSementara[index].jumlah =
                                                  newQty;
                                            });
                                          },
                                          onDelete: () {
                                            setState(() {
                                              keranjangSementara.removeAt(
                                                index,
                                              );
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Column(
                              children: [
                                SizedBox(height: 40),
                                LottieBuilder.asset(
                                  "json/empty.json",
                                  repeat: false,
                                ),
                                Text(
                                  "Belum ada pesanan",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ],
            ),
            // Total bayar
            keranjangSementara.isEmpty
                ? Container()
                : Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.biru,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                !cekTransaksi()
                                    ? "Total Bayar"
                                    : "Total Belanja",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.putih,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                formatRupiah(getTotalPesanan()),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.putih,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                String namaPemesan = controller.text.trim();

                                final String orderId =
                                    'ORDER-$namaPemesan Meja ${widget.mejaID}-${DateTime.now().millisecondsSinceEpoch}';

                                setState(() {
                                  isWaiting = true;
                                });
                                if (widget.mejaID != "null" &&
                                    namaPemesan != "") {
                                  //PEMESANAN MELALUI WEB
                                  // Tambahkan metode pembayaran ke semua item
                                  for (var item in keranjangSementara) {
                                    item.metodePembayaran = "QRIS";

                                    item.mejaID =
                                        "$namaPemesan Meja ${widget.mejaID}";
                                    item.status = "Pending";
                                    item.orderId = orderId;
                                  }
                                } else if (namaPemesan != "") {
                                  //PEMESANAN MELALUI APLIKASI KASIR DAN TIDAK PERLU MIDTRANS, BAYAR LANGSUNG
                                  setState(() {
                                    isWaiting = true;
                                    for (var item in keranjangSementara) {
                                      item.metodePembayaran = "Kasir";
                                      item.mejaID = namaPemesan;
                                      item.status = "Confirm";
                                      item.orderId = orderId;
                                    }
                                  });
                                } else if (namaPemesan == "" ||
                                    widget.mejaID == null) {
                                  if (!cekTransaksi()) {
                                    setState(() {
                                      isWaiting = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Masukkan Nama Pemesan"),
                                      ),
                                    );
                                    return;
                                  } else {
                                    //TRANSAKSI PENGELUARAN
                                    setState(() {
                                      isWaiting = true;
                                      for (var item in keranjangSementara) {
                                        item.metodePembayaran = "Cash";
                                        item.mejaID = nama;
                                        item.status = "Done";
                                        item.orderId = orderId;
                                      }
                                    });
                                  }
                                }

                                bool success = await ApiService()
                                    .insertPesananList(keranjangSementara);

                                if (success) {
                                  if (namaPemesan != "" &&
                                      widget.mejaID != "null") {
                                    setState(() {
                                      isWaiting = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MidtransPaymentPage(
                                            namaPemesan: namaPemesan,
                                            totalBayar: getTotalPesanan(),
                                            orderId: orderId,
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    customDialog(
                                      context,
                                      () {
                                        setState(() {
                                          keranjangSementara.clear();
                                          isWaiting = false;
                                        });
                                      },
                                      "json/success.json",
                                      "Pesanan berhasil diorder",
                                    );
                                  }
                                } else {
                                  customDialog(
                                    context,
                                    () {
                                      setState(() {
                                        isWaiting = false;
                                      });
                                    },
                                    "json/failed.json",
                                    "Pesanan gagal, coba lagi nanti",
                                  );
                                }
                              } catch (e) {
                                setState(() {
                                  isWaiting = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Terjadi kesalahan: $e"),
                                  ),
                                );
                              }
                            },

                            child:
                                isWaiting
                                    ? Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      child: CircularProgressIndicator(
                                        color: AppColors.putih,
                                      ),
                                    )
                                    : Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.putih,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                      ),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        !cekTransaksi() ? "PESAN" : "INPUT",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.hitam,
                                        ),
                                      ),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
