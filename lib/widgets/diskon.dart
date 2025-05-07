import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class KodePromo extends StatefulWidget {
  const KodePromo({super.key});

  @override
  State<KodePromo> createState() => _KodePromoState();
}

class _KodePromoState extends State<KodePromo> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: AppColors.abuMuda,
        ),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.circleCheck, color: AppColors.biru),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                "Kode Promo",
                style: TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
