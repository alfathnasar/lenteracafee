import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lenteracafe/colors/appColors.dart';
import 'package:lenteracafe/pages/pesanan.dart';
import 'package:lenteracafe/pages/profile.dart';
import 'package:lenteracafe/pages/transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart'; // import file home.dart

class Homepage extends StatefulWidget {
  final int? index;
  const Homepage({super.key, this.index});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;
  String nama = "", jabatan = "";

  Future<void> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? "";
      jabatan = prefs.getString('jabatan') ?? "";
    });
  }

  List<Widget> getTabs() {
    if (jabatan == "Owner") {
      return [
        const Home(),
        const Pesanan(),
        const Transaksi(),
        const Profile(),
      ];
    } else {
      return [const Home(), const Pesanan(), const Profile()];
    }
  }

  List<GButton> getTabButtons() {
    if (jabatan == "Owner") {
      return const [
        GButton(icon: FontAwesomeIcons.house, text: 'Awal', iconSize: 15),
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
      ];
    } else {
      return const [
        GButton(icon: FontAwesomeIcons.house, text: 'Awal', iconSize: 15),
        GButton(
          icon: FontAwesomeIcons.clipboardCheck,
          text: 'Pesanan',
          iconSize: 15,
        ),
        GButton(icon: Icons.person, text: "Profile", iconSize: 20),
      ];
    }
  }

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('Izin notifikasi diberikan');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // print('Izin notifikasi sementara diberikan');
    } else {
      // print('Izin notifikasi ditolak');
    }
  }

  @override
  void initState() {
    super.initState();
    getUsername();
    requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = getTabs();
    final tabButtons = getTabButtons();

    return Scaffold(
      backgroundColor: AppColors.hitam,
      body: Stack(
        children: [
          Positioned.fill(
            child: IndexedStack(index: _selectedIndex, children: tabs),
          ),
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
                selectedIndex:
                    _selectedIndex >= tabButtons.length ? 0 : _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                textStyle: const TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
                tabs: tabButtons,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
