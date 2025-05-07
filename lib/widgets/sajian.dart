// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class Sajian extends StatefulWidget {
  final Function(String) onSelect;

  const Sajian({super.key, required this.onSelect});

  @override
  State<Sajian> createState() => _SajianState();
}

class _SajianState extends State<Sajian> {
  String selectedCategory = 'Dingin'; // default yang dipilih

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });

    widget.onSelect(category); // kirim balik ke parent
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Sajian",
            style: TextStyle(fontFamily: "Poppins", fontSize: 18),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              // ICE BUTTON
              GestureDetector(
                onTap: () => selectCategory('Dingin'),
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selectedCategory == 'Dingin'
                            ? AppColors.hitam
                            : AppColors.abu,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SvgPicture.asset(
                          'img/ice.svg',
                          height: 50,
                          width: 50,
                          fit: BoxFit.scaleDown,
                          color:
                              selectedCategory == 'Dingin'
                                  ? AppColors.putih
                                  : AppColors.hitam,
                        ),
                      ),
                      Text(
                        "Dingin",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedCategory == 'Dingin'
                                  ? AppColors.putih
                                  : AppColors.hitam,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // HOT BUTTON
              GestureDetector(
                onTap: () => selectCategory('Panas'),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selectedCategory == 'Panas'
                            ? AppColors.hitam
                            : AppColors.abu,
                  ),
                  child: Column(
                    children: [
                      ClipOval(
                        child: SvgPicture.asset(
                          'img/hot.svg',
                          height: 50,
                          width: 50,
                          fit: BoxFit.scaleDown,
                          color:
                              selectedCategory == 'Panas'
                                  ? AppColors.putih
                                  : AppColors.hitam,
                        ),
                      ),
                      Text(
                        "Panas",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedCategory == 'Panas'
                                  ? AppColors.putih
                                  : AppColors.hitam,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
