// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/pages/menudetail.dart';
import 'package:lenteracafe/widgets/inventarisdialog.dart';

class ListMenu extends StatefulWidget {
  final String idItem, item, harga, kategori, img;
  final String? mejaID;
  final bool? updateItem;
  final VoidCallback? onUpdate;

  const ListMenu({
    super.key,
    required this.idItem,
    required this.item,
    required this.harga,
    required this.kategori,
    required this.img,
    this.mejaID,
    this.updateItem,
    this.onUpdate,
  });

  @override
  State<ListMenu> createState() => _ListMenuState();
}

class _ListMenuState extends State<ListMenu> {
  final TextEditingController _namaItemController = TextEditingController();
  final TextEditingController _hargaItemController = TextEditingController();
  String selectedValue = "Pilih Kategori";
  String? tempSelectedValue;

  List<String> listItem = [
    "Pilih Kategori",
    "Kopi",
    "Non Kopi",
    "Snack",
    "Makanan",
    "Alat dan Bahan",
    "Operasional",
  ];

  String formatHarga(String? harga) {
    if (harga == null || harga.isEmpty) return '0';
    int value = int.tryParse(harga) ?? 0;

    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}k';
    } else {
      return value.toString();
    }
  }

  Widget formatThumbnail(String? kategori, String? img) {
    if (img != "") {
      return CachedNetworkImage(
        width: double.infinity,
        height: double.infinity,
        imageUrl: img.toString(),
        placeholder:
            (context, url) => Container(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(color: AppColors.hitam),
            ),
        fit: BoxFit.cover,
      );
    } else {
      String assetPath;
      Color? color;

      switch (kategori) {
        case 'Kopi':
          assetPath = 'img/kopi.png';
          break;
        case 'Non Kopi':
          assetPath = 'img/nonkopi.png';
          break;
        case 'Makanan':
          assetPath = 'img/makanan.png';
          color = AppColors.hitam;
          break;
        case 'Snack':
          assetPath = 'img/snack.png';
          color = AppColors.hitam;
          break;
        case 'Alat dan Bahan':
          assetPath = 'img/bahan.png';
          color = AppColors.hitam;
          break;
        case 'Operasional':
          assetPath = 'img/operasional.png';
          color = AppColors.hitam;
          break;
        default:
          assetPath = 'img/logolentera.png';
      }

      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          assetPath,
          width: double.infinity,
          height: double.infinity,
          color: color,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaItemController.dispose();
    _hargaItemController.dispose(); // Tambahkan ini
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _namaItemController.text = widget.item;
    selectedValue = widget.kategori;
    tempSelectedValue = selectedValue;

    _hargaItemController.text = widget.harga;
    return GestureDetector(
      onTap: () async {
        if (widget.updateItem == true) {
          final dynamic result = await showInventarisDialog(
            context: context,
            namaItemController: _namaItemController,
            hargaItemController: _hargaItemController,
            listItem: listItem,
            selectedValue: widget.kategori,
            onCategoryChanged: (value) {
              tempSelectedValue = value;
            },
            isEdit: true,
          );

          //Jika batal, reset controller
          if (result == true) {
            try {
              final success = await ApiService().updateInventaris(
                id: int.parse(widget.idItem),
                namaItem: _namaItemController.text.trim(),
                kategori: tempSelectedValue.toString(),
                harga: int.parse(_hargaItemController.text),
              );

              if (success) {
                if (widget.onUpdate != null) {
                  widget.onUpdate!();
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item berhasil diperbarui')),
                );
                //fetchListInventaris(); // refresh list jika perlu
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal memperbarui item')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          } else if (result == 'delete') {
            try {
              final success = await ApiService().deleteInventaris(
                id: int.parse(widget.idItem),
              );

              if (success) {
                if (widget.onUpdate != null) {
                  widget.onUpdate!();
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Item berhasil dihapus')),
                );
                //fetchListInventaris(); // refresh list jika perlu
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus item')),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: $e')));
            }
          } else {
            // Reset ke nilai awal
            _namaItemController.text = widget.item;
            _hargaItemController.text = widget.harga;
            tempSelectedValue = selectedValue;
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => MenuDetail(
                    idItem: widget.idItem,
                    item: widget.item,
                    harga: widget.harga,
                    kategori: widget.kategori,
                    img: widget.img,
                    mejaID: widget.mejaID,
                  ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 20),
        decoration: BoxDecoration(
          color: AppColors.abu,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: SizedBox(
                      child: formatThumbnail(
                        widget.kategori.toString(),
                        widget.img,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.putih.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          formatHarga(widget.harga),
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.abuMuda,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                widget.item.toString(),
                style: TextStyle(fontFamily: "Poppins", fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
