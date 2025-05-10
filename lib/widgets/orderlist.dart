// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class OrderList extends StatefulWidget {
  final List<Map<String, dynamic>> pesanan;

  const OrderList({super.key, required this.pesanan});

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Map<String, double> userRatings = {}; // key: item ID or namaItem
  Map<String, bool> ratingSubmitted =
      {}; // key: idItem.toString(), value: true jika rating berhasil dikirim

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
      case 'Alat dan Bahan':
        return Image.asset(
          'img/bahan.png',
          fit: BoxFit.cover,
          color: AppColors.abuMuda,
        );
      default:
        return Image.asset(
          'img/logolentera.png',
          fit: BoxFit.cover,
          color: AppColors.abuMuda,
        );
    }
  }

  String formatRupiah(String harga) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    );
    return formatter.format(int.tryParse(harga) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: AppColors.krim,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween, // To space out 'meja' and total bayar
            children: [
              Text(
                widget.pesanan[0]['meja'],
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.hitam,
                ),
              ),
              // Calculate and display total bayar
              Text(
                formatRupiah(
                  widget.pesanan.fold<int>(0, (sum, item) {
                    // Ensure the value is non-null by using ?? 0
                    int harga = int.tryParse(item['harga'].toString()) ?? 0;
                    return sum + harga;
                  }).toString(),
                ),
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

        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.pesanan.length,
          itemBuilder: (context, index) {
            final item = widget.pesanan[index];
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.abuMuda,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.hitam,
                    ),
                    child: formatThumbnail(item['kategori']),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['namaItem'] ?? '',
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          formatRupiah(item['harga'].toString()),
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        Text(
                          item['keterangan'] ?? '',
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Visibility(
                        visible: ratingSubmitted[item['id'].toString()] != true,
                        child: Column(
                          children: [
                            StarRating(
                              rating:
                                  userRatings[item['id'].toString()] ??
                                  double.tryParse(
                                    item['rating']?.toString() ?? '0',
                                  ) ??
                                  0.0,
                              starCount: 5,
                              size: 20,
                              color: Colors.amber,
                              onRatingChanged: (rating) {
                                setState(() {
                                  userRatings[item['id'].toString()] = rating;
                                });
                              },
                            ),
                            SizedBox(height: 10),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.biru,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              onPressed: () async {
                                double ratingValue =
                                    userRatings[item['id'].toString()] ?? 0.0;

                                if (ratingValue > 0) {
                                  final success = await ApiService()
                                      .updateRatingItem(
                                        idItem: item['idItem'],
                                        id: item['id'],
                                        rating: ratingValue.toDouble(),
                                      );

                                  if (success) {
                                    setState(() {
                                      ratingSubmitted[item['id'].toString()] =
                                          true;
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Rating berhasil dikirim',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text(
                                "Rate",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: ratingSubmitted[item['id'].toString()] == true,
                        child: Text(
                          "Terima Kasih",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: AppColors.hitam,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
