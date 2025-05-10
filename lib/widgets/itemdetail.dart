import 'package:flutter/material.dart';
import 'package:lenteracafe/colors/appcolors.dart';

class ItemDetail extends StatefulWidget {
  final String item, harga;
  final double rating;
  final int totalRate;
  const ItemDetail({
    super.key,
    required this.item,
    required this.harga,
    required this.rating,
    required this.totalRate,
  });

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  Widget _buildStarRating(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: AppColors.kuning, size: 20));
    }

    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: AppColors.kuning, size: 20));
    }

    while (stars.length < 5) {
      stars.add(Icon(Icons.star_border, color: AppColors.kuning, size: 20));
    }

    return Row(children: stars);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        color: AppColors.abuMuda,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              widget.harga,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppColors.hitam,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStarRating(widget.rating),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        widget.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.kuning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  "(${widget.totalRate})",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
