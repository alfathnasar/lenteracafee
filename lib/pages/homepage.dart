import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lenteracafe/colors/appColors.dart';
import 'package:lenteracafe/pages/pesanan.dart';
import 'package:lenteracafe/pages/profile.dart';
import 'package:lenteracafe/pages/transaksi.dart';
import 'home.dart'; // import file home.dart

class Homepage extends StatefulWidget {
  final int? index;
  const Homepage({super.key, this.index});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = [
    const Home(), // Halaman Home (tanpa SafeArea)
    const Pesanan(),
    const Transaksi(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hitam,
      body: Stack(
        children: [
          // Konten halaman aktif
          Positioned.fill(
            child: IndexedStack(index: _selectedIndex, children: _tabs),
          ),
          // Bottom navigation bar tetap di bawah
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: AppColors.putih,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GNav(
                backgroundColor: AppColors.putih,
                color: AppColors.abu,
                activeColor: AppColors.putih,
                tabBackgroundColor: AppColors.biru,
                gap: 5,
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                textStyle: const TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
                tabs: const [
                  GButton(
                    icon: FontAwesomeIcons.house,
                    text: 'Awal',
                    iconSize: 15,
                  ),
                  GButton(
                    icon: FontAwesomeIcons.clipboardCheck,
                    text: 'Pesanan',
                    iconSize: 15,
                  ),
                  GButton(
                    icon: FontAwesomeIcons.cashRegister,
                    text: 'Transaksi',
                    iconSize: 15,
                  ),
                  GButton(icon: Icons.person, text: "Profile", iconSize: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
