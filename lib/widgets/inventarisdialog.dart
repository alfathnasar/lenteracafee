// edit_inventaris_dialog.dart
import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appColors.dart';

Future<dynamic> showInventarisDialog({
  required BuildContext context,
  required TextEditingController namaItemController,
  required TextEditingController hargaItemController,
  required List<String> listItem,
  required String selectedValue,
  required ValueSetter<String> onCategoryChanged,
  bool isEdit = false, // true jika update, false jika create
}) {
  String tempSelectedValue = selectedValue;

  return showDialog<dynamic>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.putih,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEdit ? "Edit Inventaris" : "Tambah Inventaris",
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: namaItemController,
                    style: const TextStyle(fontFamily: "Poppins"),
                    decoration: InputDecoration(
                      labelText: "Nama Item",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: AppColors.hitam,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.biru, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: hargaItemController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontFamily: "Poppins"),
                    decoration: InputDecoration(
                      labelText: "Harga Item",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        color: AppColors.hitam,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.biru, width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButton<String>(
                      value: tempSelectedValue,
                      items:
                          listItem.map((e) {
                            return DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          tempSelectedValue = value!;
                          onCategoryChanged(tempSelectedValue);
                        });
                      },
                      isExpanded: true,
                      underline: Container(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false), // Batal
                        child: const Text(
                          "Batal",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Visibility(
                        visible: isEdit,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.redAccent,
                            ),
                          ),
                          onPressed:
                              () => Navigator.pop(context, 'delete'), // Hapus
                          child: Text(
                            "Hapus",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: AppColors.putih,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            AppColors.biru,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, true), // Simpan
                        child: Text(
                          isEdit ? "Simpan" : "Tambah",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: AppColors.putih,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
