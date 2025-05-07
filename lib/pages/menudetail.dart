// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/model/pesanan.dart';
import 'package:lenteracafe/widgets/header.dart';
import 'package:lenteracafe/widgets/itemdetail.dart';
import 'package:lenteracafe/widgets/sajian.dart';
import 'package:lenteracafe/model/session_data.dart'; // Tambahkan ini

class MenuDetail extends StatefulWidget {
  final String idItem, item, harga, kategori, img;
  final String? mejaID;

  const MenuDetail({
    super.key,
    required this.idItem,
    required this.item,
    required this.harga,
    required this.kategori,
    required this.img,
    this.mejaID,
  });

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  double rating = 4.0;
  String sajianMinuman = "Dingin", sajianMakanan = "";
  bool isToppingSelected = false;

  String getKeterangan(String kategori) {
    switch (kategori) {
      case "Kopi" || "Non Kopi":
        return sajianMinuman;
      case "Alat dan Bahan" || "Snack" || "Makanan":
        break;
      default:
    }
    return "";
  }

  Widget formatThumbnail(String? kategori, String? img) {
    if (img != "") {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: SizedBox(
          height: 400,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: img.toString(),
            placeholder:
                (context, url) => Container(
                  padding: const EdgeInsets.all(30),
                  child: CircularProgressIndicator(color: AppColors.hitam),
                ),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      switch (kategori) {
        case 'Kopi':
          return Container(
            height: 200,
            padding: EdgeInsets.only(top: 20),
            child: Image.asset('img/kopi.png', fit: BoxFit.cover),
          );
        case 'Non Kopi':
          return Container(
            height: 200,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Image.asset('img/nonkopi.png', fit: BoxFit.cover),
          );
        case 'Makanan':
          return Container(
            height: 300,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Image.asset(
              'img/makanan.png',
              fit: BoxFit.cover,
              color: AppColors.hitam,
            ),
          );
        case 'Snack':
          return Container(
            height: 300,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              'img/snack.png',
              fit: BoxFit.cover,
              color: AppColors.hitam,
            ),
          );
        case 'Alat dan Bahan':
          return Container(
            height: 300,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Image.asset(
              'img/bahan.png',
              fit: BoxFit.cover,
              color: AppColors.hitam,
            ),
          );
        default:
          return Image.asset(
            'img/logolentera.png',
            fit: BoxFit.cover,
          ); // fallback image
      }
    }
  }

  String formatRupiah(dynamic harga, {String symbol = 'Rp. '}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol,
      decimalDigits: 0,
    );

    // Kalau harga berupa string, ubah ke int dulu
    if (harga is String) {
      return formatter.format(int.tryParse(harga) ?? 0);
    } else if (harga is int) {
      return formatter.format(harga);
    } else {
      return formatter.format(0); // fallback kalau tipe tidak dikenal
    }
  }

  int quantity = 1;
  late int totalHarga;

  @override
  void initState() {
    super.initState();
    totalHarga = int.parse(widget.harga); // harga awal
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      totalHarga =
          (int.parse(widget.harga) + (isToppingSelected ? 5000 : 0)) * quantity;
    });
  }

  void decrementQuantity() {
    setState(() {
      if (quantity > 1) {
        quantity--;
        totalHarga =
            (int.parse(widget.harga) + (isToppingSelected ? 5000 : 0)) *
            quantity;
      }
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
              children: [
                Header(keterangan: "Menu Detail"),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.putih,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: formatThumbnail(widget.kategori, widget.img),
                        ),
                        ItemDetail(
                          item: widget.item,
                          harga: formatRupiah(widget.harga),
                          rating: rating,
                        ),
                        widget.kategori == "Kopi" ||
                                widget.kategori == "Non Kopi"
                            ? Sajian(
                              onSelect: (sajian) {
                                sajianMinuman = sajian;
                              },
                            )
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.kuning,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                        color: AppColors.putih,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: decrementQuantity,
                            child: Icon(
                              FontAwesomeIcons.minus,
                              color: AppColors.hitam,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.hitam,
                            ),
                          ),
                          GestureDetector(
                            onTap: incrementQuantity,
                            child: Icon(
                              FontAwesomeIcons.plus,
                              color: AppColors.hitam,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      formatRupiah(totalHarga),
                      style: TextStyle(
                        color: AppColors.hitam,
                        fontFamily: "Poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final existingIndex = keranjangSementara.indexWhere(
                          (item) =>
                              item.idItem == widget.idItem &&
                              item.kategori == widget.kategori &&
                              item.keterangan == getKeterangan(widget.kategori),
                        );

                        if (existingIndex != -1) {
                          // Jika sudah ada, tambahkan jumlah
                          setState(() {
                            keranjangSementara[existingIndex].jumlah +=
                                quantity;
                          });
                        } else {
                          // Jika belum ada, tambahkan item baru
                          keranjangSementara.add(
                            Pesanan(
                              idItem: widget.idItem,
                              item: widget.item,
                              harga: widget.harga,
                              kategori: widget.kategori,
                              jumlah: quantity,
                              keterangan: getKeterangan(widget.kategori),
                              transaksi:
                                  widget.kategori == "Alat dan Bahan"
                                      ? "Pengeluaran"
                                      : "Pemasukan",
                            ),
                          );
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Pesanan ditambahkan ke keranjang sementara",
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },

                      icon: Icon(
                        FontAwesomeIcons.cartShopping,
                        color: AppColors.hitam,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
