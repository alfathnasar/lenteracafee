import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/colors/appColors.dart';
import 'package:lenteracafe/pages/order.dart';
import 'package:lenteracafe/pages/section2.dart';
import 'package:lenteracafe/pages/section3.dart';

class Pengeluaran extends StatefulWidget {
  const Pengeluaran({super.key});

  @override
  State<Pengeluaran> createState() => _PengeluaranState();
}

class _PengeluaranState extends State<Pengeluaran> {
  Set<String> selectedChips = {}; // State untuk chips filter
  String? mejaId; // Tambahkan variabel mejaId
  String searchQuery = '';
  List<String> chips = [''];

  @override
  void initState() {
    super.initState();
  }

  void updateSelectedChips(String label) {
    setState(() {
      if (selectedChips.contains(label)) {
        selectedChips.remove(label);
      } else {
        selectedChips.add(label);
      }
    });
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.hitam,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.hitam,
          body: Stack(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 125,
                    margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                    child: Image.asset(
                      "img/logolentera.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.putih,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Section2(
                            selectedChips: selectedChips,
                            onChipToggle: updateSelectedChips,
                            onSearchChanged: updateSearchQuery,
                            chips: chips,
                          ),
                          Expanded(
                            child: Section3(
                              selectedChips: selectedChips,
                              searchQuery: searchQuery,
                              mejaID: mejaId,
                              isList: "Alat dan Bahan",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => Order(
                        mejaID: mejaId.toString(), // kirim ke halaman Order
                      ),
                ),
              );
            },
            backgroundColor: AppColors.biru,
            child: Icon(FontAwesomeIcons.cartShopping, color: AppColors.putih),
          ),
        ),
      ),
    );
  }
}
