// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class CustomPembayaranDialog extends StatefulWidget {
  final List<Map<String, dynamic>> pesananMeja;
  final int totalBayar;
  final String namaPemesan, title, status;

  const CustomPembayaranDialog({
    super.key,
    required this.pesananMeja,
    required this.totalBayar,
    required this.namaPemesan,
    required this.title,
    required this.status,
  });

  @override
  State<CustomPembayaranDialog> createState() => _CustomPembayaranDialogState();
}

class _CustomPembayaranDialogState extends State<CustomPembayaranDialog> {
  final TextEditingController uangController = TextEditingController();
  int uangDiberikan = 0;

  String _formatRupiah(String number) {
    final buffer = StringBuffer();
    final reversed = number.split('').reversed.toList();
    for (int i = 0; i < reversed.length; i++) {
      buffer.write(reversed[i]);
      if ((i + 1) % 3 == 0 && i + 1 != reversed.length) buffer.write('.');
    }
    return buffer.toString().split('').reversed.join();
  }

  Future<void> _handleKonfirmasi(String status) async {
    final success = await ApiService().updateStatusPesananList(
      widget.pesananMeja,
      status,
    );

    final isSuccess = success == true; // Pastikan success berupa bool
    return isSuccess
        ? Navigator.pop(context, true)
        : Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final kembalian =
        (uangDiberikan >= widget.totalBayar)
            ? uangDiberikan - widget.totalBayar
            : 0;

    return AlertDialog(
      title: Text(
        widget.title,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNamaPemesan(),
            ..._buildDaftarPesanan(),
            if (widget.status == "Confirm")
              _buildInputUangDanKembalian(kembalian),
            const SizedBox(height: 10),
            _buildTotalBayar(),
          ],
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.end, // ⬅️ Ini memastikan tombol di kanan
              children: [
                _buildButton(
                  "Print",
                  AppColors.hitam,
                  () => Navigator.pop(
                    context,
                  ), // Ganti dengan fungsi print jika ada
                ),
                SizedBox(width: 10), // Spacer antara tombol
                Visibility(
                  visible: widget.status != "Done",
                  child: _buildButton(
                    widget.status == "Pending" ? "Konfirmasi" : "Selesai",
                    AppColors.biru,
                    () =>
                        widget.status == "Pending"
                            ? _handleKonfirmasi("Confirm")
                            : _handleKonfirmasi("Done"),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: widget.status != "Pending",
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildButton(
                      "Tutup",
                      Colors.redAccent,
                      () => Navigator.pop(
                        context,
                      ), // Ganti dengan fungsi print jika ada
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNamaPemesan() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5),
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.krim,
      ),
      child: Text(
        widget.namaPemesan,
        style: const TextStyle(fontFamily: "Poppins", fontSize: 18),
      ),
    );
  }

  List<Widget> _buildDaftarPesanan() {
    return widget.pesananMeja.map((pesanan) {
      final nama =
          '${pesanan['namaItem']} ${pesanan['keterangan']} \nx ${pesanan['jumlah']}';
      final harga =
          int.parse(pesanan['harga'].toString()) *
          int.parse(pesanan['jumlah'].toString());
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(nama, style: const TextStyle(fontFamily: 'Poppins')),
            ),
            Text(
              'Rp. ${_formatRupiah(harga.toString())}',
              style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildInputUangDanKembalian(int kembalian) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: uangController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Uang Diberikan',
            labelStyle: const TextStyle(
              fontFamily: "Poppins",
              color: AppColors.hitam,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.hitam, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          onChanged: (value) {
            try {
              String cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
              if (cleaned.isEmpty) cleaned = '0';
              final parsed = int.parse(cleaned);
              setState(() {
                uangDiberikan = parsed;
                uangController.value = TextEditingValue(
                  text: 'Rp.${_formatRupiah(parsed.toString())}',
                  selection: TextSelection.collapsed(
                    offset: 'Rp.${_formatRupiah(parsed.toString())}'.length,
                  ),
                );
              });
            } catch (_) {}
          },
        ),
        const SizedBox(height: 15),
        const Text(
          'Kembalian:',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
        ),
        Text(
          'Rp. ${_formatRupiah(kembalian.toString())}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTotalBayar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Bayar:',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          'Rp. ${_formatRupiah(widget.totalBayar.toString())}',
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
            color: AppColors.putih,
          ),
        ),
      ),
    );
  }
}
