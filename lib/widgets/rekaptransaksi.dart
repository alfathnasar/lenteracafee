import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class RekapTransaksi extends StatefulWidget {
  final List<Map<String, dynamic>> pesananList;

  const RekapTransaksi({super.key, required this.pesananList});

  @override
  State<RekapTransaksi> createState() => _RekapTransaksiState();
}

class _RekapTransaksiState extends State<RekapTransaksi> {
  // Fungsi untuk menghitung total pemasukan atau pengeluaran
  int hitungTotal(String tipe) {
    return widget.pesananList.where((item) => item['transaksi'] == tipe).fold(
      0,
      (sum, item) {
        return sum +
            (int.parse(item['harga'].toString()) *
                int.parse(item['jumlah'].toString()));
      },
    );
  }

  // Format ke format Rupiah
  String formatRupiah(int angka) {
    return 'Rp. ${angka.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final pemasukan = hitungTotal("Pemasukan");
    final pengeluaran = hitungTotal("Pengeluaran");

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              "Rekap Pembayaran",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.hitam,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                //untuk hp
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Kartu Pemasukan
                    Container(
                      width: 165,
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.biru,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowDown,
                            size: 30,
                            color: AppColors.putih,
                          ),
                          Column(
                            children: [
                              Text(
                                "Pemasukan",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                formatRupiah(pemasukan),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
                    // Kartu Pengeluaran
                    Container(
                      width: 165,
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.biru,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowUp,
                            size: 30,
                            color: AppColors.putih,
                          ),
                          Column(
                            children: [
                              Text(
                                "Pengeluaran",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                formatRupiah(pengeluaran),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                //untuk dekstop atau tablet
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Kartu Pemasukan
                    Container(
                      width: 270,
                      height: 100,
                      margin: EdgeInsets.only(left: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.biru,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowDown,
                            size: 30,
                            color: AppColors.putih,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Pemasukan",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                formatRupiah(pemasukan),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    // Kartu Pengeluaran
                    Container(
                      width: 270,
                      height: 100,
                      margin: EdgeInsets.only(right: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.biru,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            FontAwesomeIcons.arrowUp,
                            size: 30,
                            color: AppColors.putih,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Pengeluaran",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontSize: 24,
                                ),
                              ),
                              Text(
                                formatRupiah(pengeluaran),
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: AppColors.putih,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
