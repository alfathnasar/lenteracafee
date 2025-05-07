import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class Header extends StatefulWidget {
  final String keterangan;
  const Header({super.key, required this.keterangan});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_outlined,
              size: 25,
              color: AppColors.hitam,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              widget.keterangan,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.hitam,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
