import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/model/session_data.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  int getTotalBayar() {
    int total = 0;

    // Apply discount if total quantity is greater than a threshold (e.g., 3 items or more)
    //double diskon = (totalQuantity > 2 && totalQuantity % 2 != 0) ? 0.33 : 0.0;

    double diskon = 0;

    for (var p in keranjangSementara) {
      total += int.parse(p.harga) * p.jumlah;
    }

    double totalSetelahDiskon = total - (total * diskon);
    return totalSetelahDiskon.toInt();
  }

  int getTotalPesanan() {
    int total = 0;
    for (var p in keranjangSementara) {
      total += int.parse(p.harga) * p.jumlah;
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
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 70),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppColors.abuMuda,
        ),
        child: Column(
          mainAxisSize:
              MainAxisSize
                  .min, // ⬅️ penting biar Column nggak maksa tinggi penuh
          children: [
            // Container(
            //   margin: EdgeInsets.only(bottom: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Total Pesanan",
            //         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
            //       ),
            //       Text(
            //         formatRupiah(getTotalPesanan()),
            //         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   margin: EdgeInsets.only(bottom: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //         "Diskon",
            //         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
            //       ),
            //       Text(
            //         "10%",
            //         style: TextStyle(fontFamily: "Poppins", fontSize: 16),
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   margin: EdgeInsets.only(bottom: 10),
            //   child: Divider(color: AppColors.hitam, thickness: 2),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Bayar",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatRupiah(getTotalBayar()),
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
