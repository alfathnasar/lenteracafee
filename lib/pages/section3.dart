import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/widgets/listmenu.dart';

class Section3 extends StatefulWidget {
  final Set<String> selectedChips;
  final String? mejaID;
  final String searchQuery;
  final String isList;

  const Section3({
    super.key,
    required this.selectedChips,
    required this.searchQuery,
    this.mejaID,
    required this.isList,
  });

  @override
  State<Section3> createState() => _Section3State();
}

class _Section3State extends State<Section3> {
  late ApiService _apiService;
  List<Map<String, dynamic>> _menuList = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    fetchMenuList();
  }

  Future<void> fetchMenuList() async {
    try {
      late List<Map<String, dynamic>> menu;
      if (widget.isList == "Menu") {
        menu = await _apiService.fetchListMenu();
      } else if (widget.isList == "Alat dan Bahan") {
        menu = await _apiService.fetchListAlatdanBahan();
      } else if (widget.isList == "Inventaris") {
        menu = await _apiService.fetchListInventaris();
      }
      setState(() {
        _menuList = menu;
      });
    } catch (e) {
      setState(() {
        _menuList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lowerQuery = widget.searchQuery.toLowerCase();

    List<Map<String, dynamic>> filteredMenu =
        _menuList.where((item) {
          final matchChip =
              widget.selectedChips.isEmpty ||
              widget.selectedChips.contains(item['kategori']);
          final matchSearch = item['namaItem']
              .toString()
              .toLowerCase()
              .contains(lowerQuery);
          return matchChip && matchSearch;
        }).toList();

    return filteredMenu.isEmpty
        ? const Center(child: Text("Tidak ada menu ditemukan"))
        : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            StaggeredGrid.count(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children:
                  filteredMenu.map((item) {
                    return ListMenu(
                      idItem: item['id'],
                      item: item['namaItem'],
                      harga: item['harga'].toString(),
                      kategori: item['kategori'].toString(),
                      img: item['img'].toString(),
                      updateItem: widget.isList == "Inventaris",
                      onUpdate: () => fetchMenuList(),
                      rating: double.parse(item['rating']),
                    );
                  }).toList(),
            ),
          ],
        );
  }
}
