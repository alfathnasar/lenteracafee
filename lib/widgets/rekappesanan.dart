import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class RekapPesanan extends StatefulWidget {
  final List<Map<String, dynamic>> pesananList;

  const RekapPesanan({super.key, required this.pesananList});

  @override
  State<RekapPesanan> createState() => _RekapPesananState();
}

class _RekapPesananState extends State<RekapPesanan> {
  int countByStatus(String status) {
    return widget.pesananList
        .where((item) => item['status'].toString().toLowerCase() == status)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    //final menunggu = countByStatus('pending');
    final proses = countByStatus('confirm');
    final selesai = countByStatus('done');

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, bottom: 10),
            child: Text(
              "Rekap Pesanan Hari Ini",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.hitam,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Menunggu - Pending
                    // buildCard(
                    //   icon: FontAwesomeIcons.solidClock,
                    //   label: "Menunggu",
                    //   count: menunggu,
                    //   color: Colors.redAccent,
                    // ),
                    // Proses - Confirm
                    buildCard(
                      icon: Icons.pie_chart_sharp,
                      label: "Proses",
                      count: proses,
                      color: Colors.yellow[800]!,
                      height: 70,
                      width: 165,
                      fontSize: 16,
                    ),
                    // Selesai - Done
                    buildCard(
                      icon: FontAwesomeIcons.solidCircleCheck,
                      label: "Selesai",
                      count: selesai,
                      color: Colors.green[600]!,
                      height: 70,
                      width: 165,
                      fontSize: 16,
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    // Menunggu - Pending
                    // buildCard(
                    //   icon: FontAwesomeIcons.solidClock,
                    //   label: "Menunggu",
                    //   count: menunggu,
                    //   color: Colors.redAccent,
                    // ),
                    // Proses - Confirm
                    buildCard(
                      icon: Icons.pie_chart_sharp,
                      label: "Proses",
                      count: proses,
                      color: Colors.yellow[800]!,
                      height: 100,
                      width: 275,
                      fontSize: 24,
                    ),
                    // Selesai - Done
                    buildCard(
                      icon: FontAwesomeIcons.solidCircleCheck,
                      label: "Selesai",
                      count: selesai,
                      color: Colors.green[600]!,
                      height: 100,
                      width: 275,
                      fontSize: 24,
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required double width,
    required double height,
    required double fontSize,
  }) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, size: 30, color: AppColors.putih),
          Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: AppColors.putih,
                  fontSize: fontSize,
                ),
              ),
              Text(
                count.toString(),
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: AppColors.putih,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
