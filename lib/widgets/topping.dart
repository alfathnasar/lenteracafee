import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class Topping extends StatefulWidget {
  final Function(String) onSelect;

  const Topping({super.key, required this.onSelect});

  @override
  State<Topping> createState() => _ToppingState();
}

class _ToppingState extends State<Topping> {
  String selectedCategory = ''; // default yang dipilih

  void selectCategory(String category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = ''; // unselect
        widget.onSelect(''); // kirim balik kosong
      } else {
        selectedCategory = category;
        widget.onSelect(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Varian",
            style: TextStyle(fontFamily: "Poppins", fontSize: 18),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20),
          child: Row(
            children: [
              // Telur BUTTON
              GestureDetector(
                onTap: () => selectCategory('Telur'),
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selectedCategory == 'Telur'
                            ? AppColors.hitam
                            : AppColors.abu,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/telur.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.scaleDown,
                        color:
                            selectedCategory == 'Telur'
                                ? AppColors.putih
                                : AppColors.hitam,
                      ),
                      Text(
                        "Telur",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedCategory == 'Telur'
                                  ? AppColors.putih
                                  : AppColors.hitam,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Sosis BUTTON
              GestureDetector(
                onTap: () => selectCategory('Sosis'),
                child: Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selectedCategory == 'Sosis'
                            ? AppColors.hitam
                            : AppColors.abu,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/sosis.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.scaleDown,
                        color:
                            selectedCategory == 'Sosis'
                                ? AppColors.putih
                                : AppColors.hitam,
                      ),
                      Text(
                        "Sosis",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedCategory == 'Sosis'
                                  ? AppColors.putih
                                  : AppColors.hitam,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Nugget BUTTON
              GestureDetector(
                onTap: () => selectCategory('Nugget'),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        selectedCategory == 'Nugget'
                            ? AppColors.hitam
                            : AppColors.abu,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'img/nugget.png',
                        height: 40,
                        width: 40,
                        fit: BoxFit.scaleDown,
                        color:
                            selectedCategory == 'Nugget'
                                ? AppColors.putih
                                : AppColors.hitam,
                      ),
                      Text(
                        "Nugget",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedCategory == 'Nugget'
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
