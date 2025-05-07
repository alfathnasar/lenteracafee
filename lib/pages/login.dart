// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lenteracafe/pages/homepage.dart';
import 'package:lenteracafe/widgets/loginform.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.getBool('isLogin') ?? false;
    if (isLogin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const Homepage();
          },
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.hitam,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.kuning, AppColors.putih],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 250,
                child: Image.asset("img/logolentera.png", fit: BoxFit.contain),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: const Loginform(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
