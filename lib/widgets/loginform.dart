// ignore_for_file: use_build_context_synchronously

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/API/apiservice.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/pages/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginform extends StatefulWidget {
  const Loginform({super.key});

  @override
  State<Loginform> createState() => _LoginformState();
}

class _LoginformState extends State<Loginform> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearUsername() {
    setState(() {
      _usernameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.putih,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Username Field
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.biru,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.person, size: 40, color: AppColors.putih),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _usernameController,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontFamily: "Poppins"),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: TextStyle(
                      fontFamily: "Poppins",
                      color: AppColors.hitam,
                    ),
                    suffixIcon:
                        _usernameController.text.isNotEmpty
                            ? IconButton(
                              onPressed: _clearUsername,
                              icon: const Icon(FontAwesomeIcons.xmark),
                            )
                            : null,
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
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Password Field
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.biru,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(Icons.lock, size: 40, color: AppColors.putih),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontFamily: "Poppins"),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(
                      fontFamily: "Poppins",
                      color: AppColors.hitam,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
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
              ),
            ],
          ),
          Visibility(
            visible: !isLoading,
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                final response = await ApiService().loginUser(
                  _usernameController.text.trim(),
                  _passwordController.text.trim(),
                );

                if (response.containsKey('nama') &&
                    response.containsKey('jabatan')) {
                  // Login berhasil
                  String nama = response['nama'];
                  String jabatan = response['jabatan'];

                  try {
                    String? fcmToken =
                        await FirebaseMessaging.instance.getToken();

                    final success = await ApiService().updateToken(
                      username: _usernameController.text,
                      token: fcmToken.toString(),
                    );

                    if (success) {
                      setState(() {
                        isLoading = false;
                      });
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setString('nama', nama);
                      await prefs.setString('jabatan', jabatan);
                      await prefs.setBool('isLogin', true);

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Homepage()),
                        );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menambahkan token'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }

                  // Lanjutkan navigasi...
                } else {
                  setState(() {
                    isLoading = false;
                  });
                  String errorMessage =
                      response['error'] ?? 'Login failed. Please try again.';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },

              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: AppColors.biru,
                ),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.putih,
                  ),
                ),
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.only(top: 20),
            child: Visibility(
              visible: isLoading,
              child: CircularProgressIndicator(color: AppColors.biru),
            ),
          ),
        ],
      ),
    );
  }
}
