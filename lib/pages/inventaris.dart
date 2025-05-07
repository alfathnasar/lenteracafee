// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/pages/section2.dart';
import 'package:lenteracafe/pages/section3.dart';
import 'package:lenteracafe/widgets/header.dart';
import 'package:lenteracafe/widgets/inventarisdialog.dart';

class Inventaris extends StatefulWidget {
  const Inventaris({super.key});

  @override
  State<Inventaris> createState() => _InventarisState();
}

class _InventarisState extends State<Inventaris> {
  Key section3Key = UniqueKey();
  Set<String> selectedChips = {}; // State untuk chips filter

  List<String> chips = [
    'Kopi',
    'Non Kopi',
    'Snack',
    'Makanan',
    'Alat dan Bahan',
  ];

  List<String> listItem = [
    "Pilih Kategori",
    "Kopi",
    "Non Kopi",
    "Snack",
    "Makanan",
    "Alat dan Bahan",
  ];

  String searchQuery = '';
  final TextEditingController _namaItemController = TextEditingController();
  final TextEditingController _hargaItemController = TextEditingController();
  String selectedValue = 'Pilih Kategori'; // Pilih kategori default

  void addInventaris() async {
    final dynamic result = await showInventarisDialog(
      context: context,
      namaItemController: _namaItemController,
      hargaItemController: _hargaItemController,
      listItem: listItem,
      selectedValue: selectedValue,
      onCategoryChanged: (value) {
        selectedValue = value;
      },
      isEdit: false, // Menambah inventaris baru
    );

    if (result == true) {
      // Lakukan API request untuk menambah inventaris baru
      try {
        final success = await ApiService().insertInventaris(
          namaItem: _namaItemController.text.trim(),
          kategori: selectedValue,
          harga: int.parse(_hargaItemController.text),
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inventaris berhasil ditambahkan')),
          );
          setState(() {
            _namaItemController.clear();
            _hargaItemController.clear();
            selectedValue = 'Pilih Kategori';
            section3Key = UniqueKey(); // ini akan memaksa Section3 rebuild
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menambahkan inventaris')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          addInventaris();
        },
        backgroundColor: AppColors.biru,
        child: Icon(FontAwesomeIcons.plus, color: AppColors.putih),
      ),
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
                Header(keterangan: "Inventaris"),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: AppColors.putih,
                    ),
                    padding: EdgeInsets.only(top: 20),
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
                            key: section3Key,
                            selectedChips: selectedChips,
                            searchQuery: searchQuery,
                            isList: "Inventaris",
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
      ),
    );
  }
}
