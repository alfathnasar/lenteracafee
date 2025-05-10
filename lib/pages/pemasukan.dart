import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/pages/order.dart';
import 'package:lenteracafe/pages/section2.dart';
import 'package:lenteracafe/pages/section3.dart';
import 'package:lenteracafe/widgets/header.dart';

class Pemasukan extends StatefulWidget {
  const Pemasukan({super.key});

  @override
  State<Pemasukan> createState() => _PemasukanState();
}

class _PemasukanState extends State<Pemasukan> {
  Set<String> selectedChips = {}; // State untuk chips filter
  List<String> chips = ['Kopi', 'Non Kopi', 'Snack', 'Makanan'];
  String? mejaId; // Tambahkan variabel mejaId
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    final uri = Uri.base;
    mejaId = uri.queryParameters['meja'];
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

  //int _selectedIndex = 0;

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
                  mejaId != null
                      ? Container(
                        height: 125,
                        margin: EdgeInsets.only(left: 20, top: 20, bottom: 20),
                        child: Image.asset(
                          "img/logolentera.png",
                          fit: BoxFit.cover,
                        ),
                      )
                      : Header(keterangan: "Daftar Menu"),
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
                              isList: "Menu",
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
