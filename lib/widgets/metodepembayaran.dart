import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class Metodepembayaran extends StatefulWidget {
  final Function(String)? onChanged;
  const Metodepembayaran({super.key, this.onChanged});

  @override
  State<Metodepembayaran> createState() => _MetodepembayaranState();
}

class _MetodepembayaranState extends State<Metodepembayaran> {
  String _selectedPaymentMethod = 'Kasir';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20, bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.abuMuda,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        children: [
          RadioListTile<String>(
            title: Text("Kasir", style: TextStyle(fontFamily: "Poppins")),
            value: 'Kasir',
            activeColor: AppColors.biru,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
              widget.onChanged?.call(value.toString());
            },
          ),
          RadioListTile<String>(
            title: Text("QRIS", style: TextStyle(fontFamily: "Poppins")),
            value: 'QRIS',
            activeColor: AppColors.biru,
            groupValue: _selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                _selectedPaymentMethod = value!;
              });
              widget.onChanged?.call(value.toString());
            },
          ),
        ],
      ),
    );
  }
}
