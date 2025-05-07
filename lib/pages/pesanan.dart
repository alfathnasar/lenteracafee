import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appColors.dart';
import 'package:lenteracafe/widgets/pesananlist.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pesanan extends StatefulWidget {
  const Pesanan({super.key});

  @override
  State<Pesanan> createState() => _PesananState();
}

class _PesananState extends State<Pesanan> {
  late ApiService _apiService;
  DateTime tanggal = DateTime.now();
  int _currentIndex = 0;
  late StreamController<List<Map<String, dynamic>>> _pesananStreamController;
  late Timer _autoRefreshTimer;
  String nama = "", jabatan = "";

  @override
  void initState() {
    super.initState();
    getUsername();
    _apiService = ApiService();
    _pesananStreamController =
        StreamController<List<Map<String, dynamic>>>.broadcast();

    fetchListPesanan();

    _autoRefreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchListPesanan();
    });
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "";
      jabatan = prefs.getString('jabatan') ?? "";
    });
  }

  Future<void> fetchListPesanan() async {
    try {
      final pesananList = await _apiService.fetchListTransaksi();
      _pesananStreamController.add(pesananList);
    } catch (e) {
      _pesananStreamController.add([]);
    }
  }

  String hitungTotal(List<Map<String, dynamic>> list) {
    int total = list.fold(0, (sum, item) {
      return sum +
          (int.parse(item['harga'].toString()) *
              int.parse(item['jumlah'].toString()));
    });

    return 'Rp. ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    final DateFormat formatter = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ); // Using Indonesian locale
    return formatter.format(parsedDate);
  }

  String getStatusFromIndex(int index) {
    switch (index) {
      case 0:
        return 'Pending';
      case 1:
        return 'Confirm';
      case 2:
        return 'Done';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _pesananStreamController.close();
    _autoRefreshTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kuning,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 125,
                      margin: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Image.asset(
                        "img/logolentera.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Text(
                        nama,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          color: AppColors.putih,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(3000),
                      initialDate: tanggal,
                    );
                    if (selectedDate != null) {
                      setState(() {
                        tanggal = selectedDate;
                      });
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.abuMuda,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      formatDate(tanggal.toString()),
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: AppColors.hitam,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 40,
                  ),
                  child: AnimatedToggleSwitch<int>.size(
                    current: _currentIndex,
                    style: ToggleStyle(
                      backgroundColor: AppColors.abuMuda,
                      indicatorColor: AppColors.biru,
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                      indicatorBorderRadius: BorderRadius.circular(100),
                    ),
                    values: const [0, 1, 2],
                    iconOpacity: 1.0,
                    selectedIconScale: 1.0,
                    indicatorSize: const Size.fromWidth(250),
                    iconAnimationType: AnimationType.onHover,
                    styleAnimationType: AnimationType.onHover,
                    spacing: 2.0,

                    customIconBuilder: (context, local, global) {
                      final text =
                          const ['Menunggu', 'Proses', 'Selesai'][local.index];
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.lerp(
                              AppColors.abu,
                              AppColors.putih,
                              local.animationValue,
                            ),
                          ),
                        ),
                      );
                    },
                    borderWidth: 0.0,
                    onChanged: (i) => setState(() => _currentIndex = i),
                  ),
                ),

                Expanded(
                  child: StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _pesananStreamController.stream,
                    builder: (context, snapshot) {
                      final data = snapshot.data ?? [];
                      final selectedDateStr = DateFormat(
                        'yyyy-MM-dd',
                      ).format(tanggal);
                      final status = getStatusFromIndex(_currentIndex);

                      final filteredData =
                          data.where((pesanan) {
                            final pesananDateStr =
                                pesanan['tanggal'].toString().split(' ').first;
                            return pesananDateStr == selectedDateStr &&
                                pesanan['status'] == status &&
                                pesanan['transaksi'] == "Pemasukan";
                          }).toList();

                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return filteredData.isEmpty
                              ? ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    color: AppColors.putih,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      LottieBuilder.asset(
                                        "json/empty.json",
                                        repeat: false,
                                        height: 350,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Pesanan Kosong",
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      color: AppColors.putih,
                                    ),
                                    child: PesananList(
                                      pesananList: filteredData,
                                      total: hitungTotal(filteredData),
                                      isTransaksi: false,
                                    ),
                                  ),
                                ),
                              );
                        },
                      );
                    },
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
