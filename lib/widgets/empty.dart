import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appcolors.dart';
import 'package:lottie/lottie.dart';

class Empty extends StatefulWidget {
  const Empty({super.key});

  @override
  State<Empty> createState() => _EmptyState();
}

class _EmptyState extends State<Empty> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LottieBuilder.asset("json/empty.json", repeat: false, width: 350),
        Text(
          "Belum ada pesanan",
          style: TextStyle(
            fontFamily: "Poppins",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.hitam,
          ),
        ),
      ],
    );
  }
}
