import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/model/pesanan.dart';

class Keranjanglist extends StatefulWidget {
  final Pesanan pesanan;
  final Function(int) onUpdate;
  final VoidCallback onDelete;

  const Keranjanglist({
    super.key,
    required this.pesanan,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<Keranjanglist> createState() => _KeranjanglistState();
}

class _KeranjanglistState extends State<Keranjanglist> {
  late int quantity;
  late int totalHarga;

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
      case 'Operasional':
        return Image.asset(
          'img/operasional.png',
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
  void initState() {
    super.initState();
    quantity = widget.pesanan.jumlah;
    totalHarga = int.parse(widget.pesanan.harga) * quantity;
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
      totalHarga = int.parse(widget.pesanan.harga) * quantity;
    });
    widget.onUpdate(quantity); // callback ke parent
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
        totalHarga = int.parse(widget.pesanan.harga) * quantity;
      });
      widget.onUpdate(quantity); // callback ke parent
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
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => widget.onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Hapus',
          ),
        ],
      ),
      child: Container(
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
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: AppColors.hitam,
              ),
              child: formatThumbnail(widget.pesanan.kategori),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pesanan.item,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    formatRupiah(widget.pesanan.harga),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  Text(
                    widget.pesanan.keterangan,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              width: 100,
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
                      size: 18,
                    ),
                  ),
                  Text(
                    quantity.toString(),
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.hitam,
                    ),
                  ),
                  GestureDetector(
                    onTap: incrementQuantity,
                    child: Icon(
                      FontAwesomeIcons.plus,
                      color: AppColors.hitam,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
