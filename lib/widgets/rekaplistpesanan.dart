import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class RekapListPesanan extends StatefulWidget {
  final List<Map<String, dynamic>> pesananList;

  const RekapListPesanan({super.key, required this.pesananList});

  @override
  State<RekapListPesanan> createState() => _RekapListPesananState();
}

class _RekapListPesananState extends State<RekapListPesanan> {
  Widget formatThumbnail(String? kategori) {
    switch (kategori) {
      case 'Kopi':
        return Image.asset(
          'img/kopi.png',
          fit: BoxFit.cover,
          color: AppColors.abuMuda,
        );
      case 'Non Kopi':
        return Image.asset(
          'img/nonkopi.png',
          fit: BoxFit.cover,
          color: AppColors.abuMuda,
        );
      case 'Makanan':
        return Image.asset(
          'img/makanan.png',
          fit: BoxFit.cover,
          color: AppColors.abuMuda,
        );
      case 'Snack':
        return Image.asset(
          'img/snack.png',
          fit: BoxFit.cover,
          color: AppColors.abuMuda,
        );
      default:
        return Image.asset(
          'img/logolentera.png',
          fit: BoxFit.cover,
          color: AppColors.abuMuda,
        ); // fallback image
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, bottom: 5),
          child: Text(
            "Pesanan",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        ...widget.pesananList.map((pesanan) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: AppColors.abuMuda,
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppColors.hitam,
                  ),
                  child: formatThumbnail(pesanan['kategori']),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pesanan['namaItem'] ?? '',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp. ${pesanan['harga'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                      Text(
                        pesanan['keterangan']?.toString().isNotEmpty == true
                            ? pesanan['keterangan']
                            : "-",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "x ${pesanan['jumlah']}",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
