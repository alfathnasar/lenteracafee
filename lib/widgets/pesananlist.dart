import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package untuk format tanggal
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/widgets/customPembayaranDialog.dart';

class PesananList extends StatelessWidget {
  final List<Map<String, dynamic>> pesananList;
  final String total;
  final bool isTransaksi;

  const PesananList({
    super.key,
    required this.pesananList,
    required this.total,
    required this.isTransaksi,
  });

  @override
  Widget build(BuildContext context) {
    // Kelompokkan pesanan berdasarkan tanggal -> meja
    final Map<String, Map<String, List<Map<String, dynamic>>>> grouped = {};

    for (var pesanan in pesananList) {
      final tanggal = pesanan['tanggal'].toString().split(' ').first;
      final meja = pesanan['meja'].toString();

      grouped.putIfAbsent(tanggal, () => {});
      grouped[tanggal]!.putIfAbsent(meja, () => []);
      grouped[tanggal]![meja]!.add(pesanan);
    }

    return Container(
      margin: EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        color: AppColors.putih,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          for (var tanggal in grouped.keys) ...[
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //   child: Text(
            //     formatDate(tanggal),
            //     style: TextStyle(
            //       fontFamily: 'Poppins',
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: AppColors.hitam,
            //     ),
            //   ),
            // ),
            for (var meja in grouped[tanggal]!.keys) ...[
              GestureDetector(
                onTap: () async {
                  if (!isTransaksi) {
                    final totalPerMeja = int.parse(
                      _getTotalPerMeja(grouped[tanggal]![meja]!),
                    );
                    final namaPemesan =
                        grouped[tanggal]![meja]!.first['meja'] ?? 'Anonim';

                    final status = grouped[tanggal]![meja]!.first['status'];
                    await showDialog(
                      context: context,
                      builder:
                          (context) => CustomPembayaranDialog(
                            pesananMeja: grouped[tanggal]![meja]!,
                            totalBayar: totalPerMeja,
                            namaPemesan: namaPemesan,
                            status: status,
                            title:
                                status == "Confirm"
                                    ? "Selesaikan Pesanan"
                                    : "Konfirmasi Pesanan",
                          ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppColors.krim,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meja,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.hitam,
                        ),
                      ),
                      Text(
                        'Rp. ${_formatRupiah(_getTotalPerMeja(grouped[tanggal]![meja]!))}',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.hitam,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ...grouped[tanggal]![meja]!.map((pesanan) {
                final nama =
                    '${pesanan['namaItem']} ${pesanan['keterangan']} \nx ${pesanan['jumlah']}';
                final harga =
                    int.parse(pesanan['harga'].toString()) *
                    int.parse(pesanan['jumlah'].toString());
                return _buildRow(
                  nama,
                  'Rp. ${_formatRupiah(harga.toString())}',
                );
              }),
            ],
          ],
          _buildRow(
            "Total",
            total,
            isBold: true,
            fontSize: 18,
            backgroundColor: Colors.redAccent,
            fontColor: AppColors.putih,
          ),
        ],
      ),
    );
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ); // Using Indonesian locale
    return formatter.format(parsedDate);
  }

  String _getTotalPerMeja(List<Map<String, dynamic>> pesananMeja) {
    int totalPerMeja = 0;
    for (var pesanan in pesananMeja) {
      final harga = int.parse(pesanan['harga'].toString());
      final jumlah = int.parse(pesanan['jumlah'].toString());
      totalPerMeja += harga * jumlah;
    }
    return totalPerMeja.toString();
  }

  Widget _buildRow(
    String left,
    String right, {
    Color backgroundColor = AppColors.putih,
    bool isBold = false,
    double fontSize = 16,
    Color fontColor = AppColors.hitam,
  }) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 210,
            child: Text(
              left,
              style: TextStyle(
                fontFamily: "Poppins",
                color: fontColor,
                fontSize: fontSize,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            right,
            style: TextStyle(
              fontFamily: "Poppins",
              color: fontColor,
              fontSize: fontSize,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRupiah(String number) {
    final buffer = StringBuffer();
    final reversed = number.split('').reversed.toList();
    for (int i = 0; i < reversed.length; i++) {
      buffer.write(reversed[i]);
      if ((i + 1) % 3 == 0 && i + 1 != reversed.length) buffer.write('.');
    }
    return buffer.toString().split('').reversed.join();
  }
}
