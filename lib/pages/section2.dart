import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class Section2 extends StatefulWidget {
  final Set<String> selectedChips;
  final List<String> chips;
  final Function(String) onChipToggle;
  final Function(String) onSearchChanged;

  const Section2({
    super.key,
    required this.selectedChips,
    required this.onChipToggle,
    required this.onSearchChanged,
    required this.chips,
  });

  @override
  State<Section2> createState() => _Section2State();
}

class _Section2State extends State<Section2> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() {
      widget.onSearchChanged(_controller.text);
      setState(() {}); // untuk update icon X saat isi berubah
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _controller
        .clear(); // otomatis memicu listener dan panggil onSearchChanged('')
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search field
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextField(
            style: TextStyle(fontFamily: "Poppins"),
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Cari Menu",
              suffixIcon:
                  _controller.text.isNotEmpty
                      ? IconButton(
                        onPressed: _clearSearch,
                        icon: const Icon(FontAwesomeIcons.xmark),
                      )
                      : null,
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ), // warna border saat tidak fokus
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.biru,
                  width: 2,
                ), // warna border saat fokus
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),
        // Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  widget.chips
                      .where(
                        (label) => label.trim().isNotEmpty,
                      ) // <-- Filter kosong
                      .map((label) {
                        final isSelected = widget.selectedChips.contains(label);
                        return GestureDetector(
                          onTap: () => widget.onChipToggle(label),
                          child: Chip(
                            label: Text(label),
                            backgroundColor:
                                isSelected ? AppColors.biru : Colors.grey[300],
                            labelStyle: TextStyle(
                              color:
                                  isSelected ? AppColors.putih : Colors.black,
                            ),
                          ),
                        );
                      })
                      .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
