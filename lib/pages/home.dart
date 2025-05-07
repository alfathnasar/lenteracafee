import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/pages/pemasukan.dart';
import 'package:lenteracafe/pages/pengeluaran.dart';
import 'package:lenteracafe/widgets/rekaplistpesanan.dart';
import 'package:lenteracafe/widgets/rekappesanan.dart';
import 'package:lenteracafe/widgets/rekaptransaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ApiService _apiService;
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

    fetchPesananList();

    _autoRefreshTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchPesananList();
    });
  }

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "";
      jabatan = prefs.getString('jabatan') ?? "";
    });
  }

  Future<void> fetchPesananList() async {
    try {
      final pesananList = await _apiService.fetchListTransaksi();
      _pesananStreamController.add(pesananList);
    } catch (e) {
      _pesananStreamController.add([]);
    }
  }

  List<Map<String, String>> formatPesananList(List<Map<String, dynamic>> list) {
    return list.map((item) {
      final nama = '${item['namaItem']} x ${item['jumlah']}';
      final harga =
          int.parse(item['harga'].toString()) *
          int.parse(item['jumlah'].toString());
      return {
        'nama': nama,
        'harga':
            'Rp. ${harga.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
      };
    }).toList();
  }

  String hitungTotal(List<Map<String, dynamic>> list) {
    int total = list.fold(0, (sum, item) {
      return sum +
          (int.parse(item['harga'].toString()) *
              int.parse(item['jumlah'].toString()));
    });

    return 'Rp. ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  void dispose() {
    _autoRefreshTimer.cancel();
    _pesananStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.kuning,
        floatingActionButton: Container(
          padding: const EdgeInsets.only(bottom: 60),
          child: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(
              color: Colors.white, // Ganti warna ikon animasi di sini
              size: 30, // Ukuran ikon animasi bisa disesuaikan
            ),
            backgroundColor: AppColors.biru,
            overlayColor: Colors.white,
            spacing: 12,
            spaceBetweenChildren: 5,
            overlayOpacity: 0.2,
            children: [
              SpeedDialChild(
                label: "Belanja",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Pengeluaran();
                      },
                    ),
                  );
                },
                labelStyle: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
                shape: const CircleBorder(),
                backgroundColor: Colors.redAccent,
                child: const Icon(
                  FontAwesomeIcons.arrowUpLong,
                  color: AppColors.putih,
                ),
              ),
              SpeedDialChild(
                label: "Pesanan",
                labelStyle: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
                shape: const CircleBorder(),
                backgroundColor: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Pemasukan();
                      },
                    ),
                  );
                },
                child: const Icon(
                  FontAwesomeIcons.arrowDownLong,
                  color: AppColors.putih,
                ),
              ),
            ],
          ),
        ),
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: AppColors.putih,
                    ),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _pesananStreamController.stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        final allData = snapshot.data ?? [];
                        final today = DateTime.now();
                        final dateFormat = DateFormat('yyyy-MM-dd');

                        final dataToday =
                            allData.where((item) {
                              final tanggal = item['tanggal'];
                              if (tanggal == null) return false;
                              final itemDate = DateTime.tryParse(
                                tanggal.toString(),
                              );
                              if (itemDate == null) return false;
                              return dateFormat.format(itemDate) ==
                                  dateFormat.format(today);
                            }).toList();

                        final dataPemasukan =
                            (dataToday)
                                .where(
                                  (item) => item['transaksi'] == 'Pemasukan',
                                ) // atau 'Pengeluaran'
                                .toList();

                        if (dataToday.isEmpty) {
                          return Center(child: Text("Tidak ada data"));
                        }

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              RekapPesanan(pesananList: dataPemasukan),
                              RekapTransaksi(pesananList: dataToday),
                              Container(
                                padding: EdgeInsets.only(bottom: 40),
                                child: RekapListPesanan(
                                  pesananList: dataPemasukan.take(5).toList(),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
