import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:futsal_now_mobile/config/app_format.dart';

class ReviewItem extends StatelessWidget {
  final String name;
  final String comment;
  final double rating;
  final DateTime date;

  const ReviewItem({
    super.key,
    required this.name,
    required this.comment,
    required this.rating,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          DView.height(8),
          Row(
            children: [
              RatingBar.builder(
                initialRating: rating,
                itemCount: 5,
                allowHalfRating: true,
                itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
                itemSize: 20,
                ignoreGestures: true,
                onRatingUpdate: (rating) {},
              ),
              DView.width(4),
              Text('(${rating.toString()})'),
            ],
          ),
          DView.height(8),
          Text(
            comment,
            style: const TextStyle(fontSize: 16),
          ),
          DView.height(10),
          Text(
            AppFormat.justDate(date), // Format tanggal sesuai kebutuhan
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
